import type { DatabaseSync } from 'node:sqlite';

import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

import { openDatabase } from '../database/database.ts';
import { deliverEmail, type EmailDelivery } from './deliver-email.ts';

const config = { serverToken: 'server-token', senderAddress: 'sender@example.org' };

const delivery: EmailDelivery = {
  profileId: 7,
  feedId: 3,
  cveId: 'CVE-2026-0001',
  isTest: false,
  message: { to: 'recipient@example.org', subject: 'CVE-2026-0001', textBody: 'A vulnerability was disclosed.' },
};

describe('deliverEmail', () => {
  let database: DatabaseSync;

  beforeEach(() => {
    database = openDatabase(':memory:');
  });

  afterEach(() => {
    vi.unstubAllGlobals();
  });

  it('hands the message to Postmark without tracking', async () => {
    const fetchMock = stubFetch(Response.json({ ErrorCode: 0, Message: 'OK', MessageID: 'message-1' }));

    await deliverEmail(database, config, delivery);

    const [url, init] = fetchMock.mock.calls[0] ?? [];
    expect(url).toBe('https://api.postmarkapp.com/email');
    expect(init?.headers).toMatchObject({ 'X-Postmark-Server-Token': 'server-token' });
    expect(JSON.parse(init?.body as string)).toEqual({
      From: 'sender@example.org',
      To: 'recipient@example.org',
      Subject: 'CVE-2026-0001',
      TextBody: 'A vulnerability was disclosed.',
      MessageStream: 'outbound',
      TrackOpens: false,
      TrackLinks: 'None',
    });
  });

  it('records an accepted message with a pending delivery status (REQ-001)', async () => {
    stubFetch(Response.json({ ErrorCode: 0, Message: 'OK', MessageID: 'message-1' }));

    const outcome = await deliverEmail(database, config, delivery);

    expect(outcome.status).toBe('pending');
    expect(readDeliveryRecord(outcome.id)).toMatchObject({
      profile_id: 7,
      feed_id: 3,
      cve_id: 'CVE-2026-0001',
      channel: 'email',
      status: 'pending',
      is_test: 0,
      provider_message_id: 'message-1',
      error_code: null,
    });
    expect(readErrorLog()).toEqual([]);
  });

  it('records a rejected message as failed with an error log entry (REQ-002)', async () => {
    stubFetch(Response.json({ ErrorCode: 300, Message: 'Invalid email request' }, { status: 422 }));

    const outcome = await deliverEmail(database, config, delivery);

    expect(outcome.status).toBe('failed');
    expect(readDeliveryRecord(outcome.id)).toMatchObject({
      status: 'failed',
      provider_message_id: null,
      error_code: '300',
    });
    expect(readErrorLog()).toEqual([
      expect.objectContaining({
        source: 'email',
        feed_id: 3,
        delivery_record_id: outcome.id,
        http_status: 422,
        error_code: '300',
        error_message: 'The email service rejected the message.',
      }),
    ]);
  });

  it('does not store the raw response of the email service in the error log', async () => {
    stubFetch(Response.json({ ErrorCode: 406, Message: 'recipient@example.org is inactive.' }, { status: 422 }));

    await deliverEmail(database, config, delivery);

    expect(JSON.stringify(readErrorLog())).not.toContain('recipient@example.org');
  });

  it('records an unreachable email service as failed with an error log entry', async () => {
    const fetchMock = stubFetch(Promise.reject(new TypeError('fetch failed')));

    const outcome = await deliverEmail(database, config, delivery);

    expect(outcome.status).toBe('failed');
    expect(fetchMock).toHaveBeenCalledOnce();
    expect(readErrorLog()).toEqual([
      expect.objectContaining({
        http_status: null,
        error_code: null,
        error_message: 'The email service could not be reached.',
      }),
    ]);
  });

  it('records a server error without a Postmark error code as failed', async () => {
    stubFetch(new Response('Internal Server Error', { status: 500 }));

    const outcome = await deliverEmail(database, config, delivery);

    expect(outcome.status).toBe('failed');
    expect(readErrorLog()).toEqual([expect.objectContaining({ http_status: 500, error_code: null })]);
  });

  it('marks a test message as a test', async () => {
    stubFetch(Response.json({ ErrorCode: 0, Message: 'OK', MessageID: 'message-2' }));

    const outcome = await deliverEmail(database, config, {
      ...delivery,
      feedId: undefined,
      cveId: undefined,
      isTest: true,
    });

    expect(readDeliveryRecord(outcome.id)).toMatchObject({ is_test: 1, feed_id: null, cve_id: null });
  });

  function stubFetch(response: Response | Promise<Response>) {
    const fetchMock = vi.fn<typeof fetch>(() => Promise.resolve(response));
    vi.stubGlobal('fetch', fetchMock);
    return fetchMock;
  }

  function readDeliveryRecord(id: number) {
    return database.prepare('SELECT * FROM delivery_record WHERE id = ?').get(id);
  }

  function readErrorLog() {
    return database.prepare('SELECT * FROM error_log').all();
  }
});
