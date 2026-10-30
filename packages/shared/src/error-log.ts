export type ErrorSource = 'cve_api' | 'email' | 'sms';

export type ErrorLogEntry = {
  id: number;
  source: ErrorSource;
  feedId?: number;
  deliveryRecordId?: number;
  attempt?: number;
  httpStatus?: number;
  errorCode?: string;
  errorMessage: string;
  createdAt: string;
};
