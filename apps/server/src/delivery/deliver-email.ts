import type { DatabaseSync } from 'node:sqlite';

import type { DeliveryRecord } from '@wp-cve/shared';

import { inTransaction } from '../database/database.ts';
import { insertErrorLogEntry } from '../error-log/error-log.ts';
import { insertDeliveryRecord, type NewDeliveryRecord } from './delivery-record.ts';
import { type EmailMessage, type EmailSubmission, type PostmarkConfig, sendEmail } from './postmark.ts';

export type EmailDelivery = Pick<NewDeliveryRecord, 'profileId' | 'feedId' | 'cveId' | 'isTest'> & {
  message: EmailMessage;
};

export type DeliveryOutcome = Pick<DeliveryRecord, 'id' | 'status'>;

type DeliveryTarget = Omit<EmailDelivery, 'message'>;

export async function deliverEmail(
  database: DatabaseSync,
  config: PostmarkConfig,
  delivery: EmailDelivery,
): Promise<DeliveryOutcome> {
  const { message, ...target } = delivery;
  const submission = await sendEmail(config, message);
  return inTransaction(database, () =>
    submission.isAccepted
      ? recordPendingDelivery(database, target, submission.messageId)
      : recordFailedDelivery(database, target, submission),
  );
}

function recordPendingDelivery(database: DatabaseSync, target: DeliveryTarget, messageId: string): DeliveryOutcome {
  const id = insertDeliveryRecord(database, {
    ...target,
    channel: 'email',
    status: 'pending',
    providerMessageId: messageId,
  });
  return { id, status: 'pending' };
}

function recordFailedDelivery(
  database: DatabaseSync,
  target: DeliveryTarget,
  { httpStatus, errorCode }: Extract<EmailSubmission, { isAccepted: false }>,
): DeliveryOutcome {
  const id = insertDeliveryRecord(database, { ...target, channel: 'email', status: 'failed', errorCode });
  insertErrorLogEntry(database, {
    source: 'email',
    feedId: target.feedId,
    deliveryRecordId: id,
    httpStatus,
    errorCode,
    errorMessage:
      httpStatus === undefined ? 'The email service could not be reached.' : 'The email service rejected the message.',
  });
  return { id, status: 'failed' };
}
