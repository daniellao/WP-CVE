# WP CVE architecture plan

This document describes the technical architecture of WP CVE. The binding rules are in the [feature files](features/), the concepts in [spec.md](spec.md) and the product use cases in [scope.md](scope.md).

## Contents

- [Architecture](#architecture)
- [Stack](#stack)
- [Project structure](#project-structure)
- [Data model](#data-model)
- [Events](#events)
- [Message delivery](#message-delivery)
- [GDPR](#gdpr)
- [Application security](#application-security)

## Architecture

```text
Browser (Angular single-page application)
   │  same origin, HttpOnly session cookie
   ▼
Node server (one container)  ──►  Identity provider of the organization (OIDC)
 ├─ serves the built Angular application
 ├─ /api/*       JSON API, application manager session checked
 ├─ /webhooks/*  delivery reports, authenticated per provider
 ├─ in-process scheduler: poll every two hours, daily purge
 └─ SQLite database file on an encrypted volume
   │ outbound connections only:
   ├─► CVE API of the NVD (5 requests per 30 seconds, 6 seconds apart)
   ├─► Postmark (email)   ◄── delivery reports
   └─► Telnyx (SMS)       ◄── delivery reports
```

The application runs as one container with one persistent volume, independent of the hosting provider. If WP CVE later needs several instances or high availability, SQLite is replaced by PostgreSQL without a change to the structure of the application.

## Stack

| Layer | Choice | Reason |
|---|---|---|
| Repository | pnpm workspace with `apps/web`, `apps/server` and `packages/shared` | One language; shared types and validators |
| Frontend | Angular v22, zoneless, signals, `OnPush`, signal forms | Matches the project style guides |
| Server | Node.js 24 LTS with Fastify | Small, fast and well maintained; built-in schema validation |
| Database | SQLite (`node:sqlite`) in WAL mode with `secure_delete` enabled; plain SQL and numbered migration files | A lightweight database without an object-relational mapping layer |
| Backups | SQLite online backup API or Litestream; encrypted; kept for 30 days | Consistent copies without stopping the application |
| Authentication | `openid-client` v6: OIDC authorization code flow with PKCE, run on the server | Certified library, independent of the identity provider; no passwords stored |
| Sessions | `@fastify/cookie` with a session table in SQLite | No additional session store |
| Email service | Postmark HTTP API | Delivery reports through webhooks |
| SMS service | Telnyx Messaging API | Delivery reports through webhooks |
| Scheduler | In-process timer with a guard against overlapping runs | One instance needs no distributed lock |
| Deployment | One container image and one volume, reachable over HTTPS for the OIDC callback and the webhooks | Independent of the hosting provider |

## Project structure

- `packages/shared`: domain types and validators used by client and server, such as `parseCpeName` (REQ-005, REQ-024, REQ-025), email address validation and E.164 phone number validation.
- `apps/server/src/<feature>/`: `recipients`, `feeds`, `polling`, `nvd-client`, `delivery`, `webhooks`, `audit-log`, `error-log`, `retention` and `auth`. Each folder contains its routes, SQL statements and logic.
- `apps/web/src/app/<feature>/`: one lazily loaded route per screen: recipient profiles, CVE feeds, test message, audit log and error log.

The footer of the application shows the notice that the NVD asks API users to display: "This product uses data from the NVD API but is not endorsed or certified by the NVD."

## Data model

| Table | Columns | Notes |
|---|---|---|
| `recipient_profile` | `id`, `email_enc`, `phone_enc`, `channels`, `consent_confirmed_at`, `consent_confirmed_by`, `created_at` | Email address and phone number encrypted per field, each stored only for a subscribed channel (REQ-026) |
| `cve_feed` | `id`, `cpe_name`, `last_cve_modified_at`, `suspended_at`, `resumed_at`, `created_at` | An empty `last_cve_modified_at` marks the first poll; a change of the CPE name empties it (REQ-039); `suspended_at` marks a suspended CVE feed (REQ-050 to REQ-052); `resumed_at` marks the end of the last suspension (REQ-057) |
| `feed_assignment` | `feed_id`, `profile_id`, `assigned_at` | One or two recipient profiles per CVE feed |
| `reported_cve` | `feed_id`, `cve_id`, `reported_at` | Unique per CVE feed and CVE; prevents duplicate notifications (REQ-012) |
| `delivery_record` | `id`, `profile_id`, `feed_id`, `cve_id`, `channel`, `status`, `is_test`, `provider_message_id`, `error_code`, `created_at`, `updated_at` | The audit log; status is `pending`, `successful` or `failed`; deleted together with the recipient profile |
| `error_log` | `id`, `source`, `feed_id`, `delivery_record_id`, `attempt`, `http_status`, `error_code`, `error_message`, `created_at` | Source is `cve_api`, `email` or `sms`; deleted together with the delivery record |
| `removed_profile` | `profile_id`, `removed_at` | Contains no personal data; replayed after a restore from backup |
| `session` | `id`, `subject`, `expires_at`, `last_seen_at` | Sessions of application managers |

Delivery records and error log entries refer to a recipient profile by its identifier and contain no email address or phone number. The error log stores the error code of the provider and a fixed description, not the raw response, which can contain contact details.

## Events

1. Every two hours the scheduler starts a poll (REQ-028). A poll does not start while the previous one is still running.
2. All requests to the CVE API pass through one queue in `nvd-client`. The queue keeps 6 seconds between requests and sends no more than 5 requests in a rolling 30 second window (REQ-031). No API key is used.
3. For each CVE feed that is not suspended (REQ-052):
   - **First poll.** When `last_cve_modified_at` is empty, for a new CVE feed or after a change of its CPE name (REQ-059), WP CVE requests all CVE for the `cpeName` of the feed, starting at `startIndex` 0 and raising it by `resultsPerPage` until `totalResults` is reached (REQ-009, REQ-027). `resultsPerPage` keeps the default value of the API, as the NVD recommends.
   - **Later polls.** WP CVE sends the same request, limited by `lastModStartDate`, set to `last_cve_modified_at`, and `lastModEndDate`, set to the current time (REQ-037). The CVE API allows a date range of no more than 120 consecutive days, so a longer period, for example after a long suspension, is split into consecutive ranges of 120 days (REQ-058).
   - **After a suspension.** CVE modified between `suspended_at` and `resumed_at` are added to `reported_cve` without being sent (REQ-057), unless the CPE name was changed during the suspension; the poll is then a first poll (REQ-066).
4. A failed request (network error or HTTP status 403, 429 or 5xx) is written to the error log and retried through the same queue, 6 seconds later, up to 10 attempts in total (REQ-029, REQ-030). When all attempts fail, the poll of that CVE feed stops and `last_cve_modified_at` keeps its value, so that the next poll covers the gap (REQ-038).
5. Each CVE that is not yet in `reported_cve` for the feed is sent to every recipient profile assigned to the feed at that moment, over each subscribed channel (REQ-010, REQ-013, REQ-014). A recipient profile assigned later therefore receives only CVE found after its assignment (REQ-032).
   - Each message creates a delivery record with status `pending` and the message identifier of the provider (REQ-001).
   - A message that the provider rejects receives status `failed` and an error log entry, and is not retried (REQ-002, REQ-015, REQ-034).
   - The CVE is then added to `reported_cve`, also when a delivery failed, so that it is not sent again (REQ-053).
6. `last_cve_modified_at` advances only after the poll of the CVE feed has completed.
7. A test message uses the same `delivery` module, with `is_test` set (REQ-021 to REQ-023).

## Message delivery

Postmark and Telnyx accept a message first and report the delivery outcome later through a webhook (REQ-033).

| Endpoint | Events | Authentication |
|---|---|---|
| `POST /webhooks/postmark` | Delivery and bounce | HTTP basic authentication credentials in the webhook URL, over HTTPS, compared in constant time |
| `POST /webhooks/telnyx` | `message.finalized` | Ed25519 signature in the `telnyx-signature-ed25519` and `telnyx-timestamp` headers, verified with the public key of Telnyx; timestamps older than 5 minutes are rejected |

Both endpoints find the delivery record by `provider_message_id` and set its status to `successful` or `failed`. A Postmark delivery event and the Telnyx status `delivered` map to `successful`; a Postmark bounce event and the Telnyx statuses `sending_failed` and `delivery_failed` map to `failed`. Postmark does not sign webhooks, so the payload structure is also validated. A failure also creates an error log entry. Repeated events have no further effect. An event for an unknown message identifier is acknowledged and ignored, since its recipient profile may have been removed.

The webhook endpoints are excluded from the session and XSRF checks, and have their own authentication, a maximum request body size and a rate limit. Raw webhook payloads are neither stored nor logged, because they contain the email address or phone number.

## GDPR

- **Consent.** A recipient requests a recipient profile by email to the helpdesk and gives consent in that email. The consent email stays in the helpdesk system. When adding the recipient profile, the application manager confirms the consent; WP CVE stores the time of confirmation and the identity of the application manager (REQ-056), and does not save a recipient profile, or a change of its email address or phone number, without it (REQ-035, REQ-048). When a recipient withdraws consent by email to the helpdesk, the helpdesk procedure has the recipient profile removed within one month; WP CVE provides the removal (REQ-018). Unsubscribing a recipient profile from a channel deletes the contact detail of that channel (REQ-017).
- **Data minimization.** WP CVE stores only the email address, phone number, subscribed channels and consent confirmation of a recipient.
- **Encryption.** The volume is encrypted. The email address and phone number are also encrypted per field with AES-256-GCM, with a key from the secret store of the host. Backups are encrypted.
- **Removal.** Removing a recipient profile (REQ-018, REQ-036):
  - deletes the recipient profile, its CVE feed assignments, its delivery records and its error log entries in one transaction, and writes a `removed_profile` entry;
  - overwrites the freed database pages through `secure_delete`, followed by a WAL checkpoint;
  - removes the data from backups within 30 days, because backups older than 30 days are destroyed (REQ-061) and a restore by the system administrator (REQ-064) replays every `removed_profile` entry before the application starts (REQ-047).

  The audit log no longer shows the deliveries of a removed recipient profile (REQ-054). Removing the only recipient profile of a CVE feed sets `suspended_at` on that CVE feed instead of blocking the removal (REQ-050).
- **Retention.** A daily job deletes delivery records, error log entries, and `removed_profile` entries older than the agreed retention period of 30 days.
- **Application logs.** The logger redacts email addresses and phone numbers.
- **Processors.** Postmark (ActiveCampaign) and Telnyx are based in the United States. Each processor has a signed data processing agreement with standard contractual clauses or coverage under the EU–US Data Privacy Framework, and an entry in the record of processing activities. Open tracking and link tracking are disabled in Postmark, and both providers keep message content for their shortest available period.

## Application security

- **Authentication.** Application managers sign in through the identity provider of the organization with OIDC and multi-factor authentication. Access depends on membership of an application manager group, provided as a claim.
- **Authorization.** One Fastify hook checks the application manager session on every `/api/*` route (REQ-020). Angular route guards only improve the user experience.
- **Session.** An opaque session identifier in a cookie with `HttpOnly`, `Secure` and `SameSite=Strict`, with an idle timeout and an absolute timeout. The XSRF token is checked on every request that changes data.
- **Browser hardening.** A strict Content Security Policy through the Angular `security.autoCsp` option, Trusted Types, HSTS, `frame-ancestors 'none'`, `Referrer-Policy` and `X-Content-Type-Options`.
- **Input validation.** Fastify JSON schemas and the shared validators check every request body. Text from the CVE API is treated as untrusted: SMS messages are plain text and email bodies are escaped.
- **Outbound connections.** Only to the identity provider, `services.nvd.nist.gov`, `api.postmarkapp.com` and `api.telnyx.com`.
- **Rate limits.** On sign-in, on test messages, which cost money when sent by SMS, and on the webhook endpoints.
- **Secrets.** The Postmark server token, the Postmark webhook credentials, the Telnyx API key and public key, the OIDC client secret, the field encryption key and the backup encryption key come from the environment or the secret store of the host, never from the repository.
- **Dependencies.** Few dependencies, a lockfile, `pnpm audit` in continuous integration and a pinned container base image.
