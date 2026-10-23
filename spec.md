# WP CVE

A CVE monitoring app that sends notifications about publicly disclosed vulnerabilities in WordPress.

## The app

WP CVE notifies relevant stakeholders when vulnerabilities in WordPress are publicly disclosed. Application managers manage the recipients of these notifications, and the information of recipients is stored encrypted and removed completely, in line with the GDPR.

Dedicated email and SMS services deliver the notifications. The choice of services is described in the [architecture plan](plan.md). WP CVE keeps track of message delivery in a database, which application managers inspect as the audit log. The [architecture plan](plan.md) describes the database.

## CVE API

The CVE API retrieves information on a single CVE or a collection of CVE from the NVD, which contains CVE records. Large collections are returned as a series of smaller "chunked" responses, controlled by an offset `startIndex` and a page limit `resultsPerPage`. This is offset-based pagination.

## CPE name

A CPE name identifies the product a CVE feed watches. It is a string of colon separated values that describe a product. In CPE 2.3, the first two values are "cpe" and "2.3", and the values that follow are the CPE components.

**Request the CVE associated with a specific CPE**

`https://services.nvd.nist.gov/rest/json/cves/2.0?cpeName=cpe:2.3:o:microsoft:windows_10:1607:*:*:*:*:*:*:*`

The values of that example, in order: `cpe` and `2.3` (the CPE 2.3 prefix), then part `o`, vendor `microsoft`, product `windows_10` and version `1607`, followed by the remaining seven components, left as "*".

## CVE feeds

A CVE feed is a configured connection to the CVE API for one product, identified by its CPE name. WP CVE polls each CVE feed and pages through its results.

The first poll of a CVE feed retrieves every CVE for its CPE name, so that its recipients learn about the known vulnerabilities in the WordPress version they run. Later polls follow the [rate limits and best practices of the NVD](https://nvd.nist.gov/developers/start-here): a poll every two hours, a pause between requests, and requests limited to the CVE modified since the last CVE received.

After a WordPress upgrade, an application manager can change the CPE name of the CVE feed; the next poll then treats the new CPE name as a first poll. Updating the CPE name after an upgrade is an organizational procedure. A CVE feed whose only recipient profile is removed is suspended: it is not polled until a recipient profile is assigned to it again, and the CVE of the suspension period are not sent to the newly assigned recipient profile.

## Delivery reports

The email service and the SMS service accept a message first and report its delivery later. A delivery report from either service updates the delivery status in the audit log from pending to successful or failed. A message that the service rejects at once is recorded as failed immediately.

## Error log

The error log records failed CVE API requests and failed deliveries, so that an application manager can investigate them. It is separate from the audit log, which records every delivery attempt.

## Consent and removal

A recipient requests a recipient profile by sending an email to the helpdesk, and gives consent in that email to the storage of their phone number and email address. An application manager then adds the recipient profile and confirms that consent was given. The consent email itself is not part of WP CVE; keeping it in the helpdesk system is an organizational measure. When a recipient withdraws consent by email to the helpdesk, the helpdesk procedure has the recipient profile removed within one month of the receipt of that email.

When a recipient profile is removed, its personal data is removed from WP CVE together with its delivery records and error log entries. Backups are encrypted and expire after 30 days, so the personal data also disappears from backups within that period. A system administrator restores WP CVE from a backup when data is lost; removed recipient profiles do not return with it.

## Recipient profiles

A recipient profile is the stored record of a single recipient, with their contact details and the channels they are subscribed to. Assigning a recipient profile to a CVE feed makes the recipient receive the vulnerability notifications of that feed from then on.

## Sending a test message

A test message is sent to a recipient profile to confirm its contact details and CVE feed assignments before a real CVE arrives.
