import type { DatabaseSync } from 'node:sqlite';

import type { DeliveryRecord } from '@wp-cve/shared';

export type NewDeliveryRecord = Omit<DeliveryRecord, 'id' | 'createdAt' | 'updatedAt'>;

export function insertDeliveryRecord(database: DatabaseSync, record: NewDeliveryRecord): number {
  const { lastInsertRowid } = database
    .prepare(
      `INSERT INTO delivery_record (profile_id, feed_id, cve_id, channel, status, is_test, provider_message_id, error_code)
       VALUES (:profileId, :feedId, :cveId, :channel, :status, :isTest, :providerMessageId, :errorCode)`,
    )
    .run({
      profileId: record.profileId,
      feedId: record.feedId ?? null,
      cveId: record.cveId ?? null,
      channel: record.channel,
      status: record.status,
      isTest: record.isTest ? 1 : 0,
      providerMessageId: record.providerMessageId ?? null,
      errorCode: record.errorCode ?? null,
    });
  return Number(lastInsertRowid);
}
