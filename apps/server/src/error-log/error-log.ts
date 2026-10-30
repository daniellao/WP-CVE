import type { DatabaseSync } from 'node:sqlite';

import type { ErrorLogEntry } from '@wp-cve/shared';

export type NewErrorLogEntry = Omit<ErrorLogEntry, 'id' | 'createdAt'>;

export function insertErrorLogEntry(database: DatabaseSync, entry: NewErrorLogEntry): void {
  database
    .prepare(
      `INSERT INTO error_log (source, feed_id, delivery_record_id, attempt, http_status, error_code, error_message)
       VALUES (:source, :feedId, :deliveryRecordId, :attempt, :httpStatus, :errorCode, :errorMessage)`,
    )
    .run({
      source: entry.source,
      feedId: entry.feedId ?? null,
      deliveryRecordId: entry.deliveryRecordId ?? null,
      attempt: entry.attempt ?? null,
      httpStatus: entry.httpStatus ?? null,
      errorCode: entry.errorCode ?? null,
      errorMessage: entry.errorMessage,
    });
}
