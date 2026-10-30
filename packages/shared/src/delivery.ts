export type Channel = 'email' | 'sms';

export type DeliveryStatus = 'pending' | 'successful' | 'failed';

export type DeliveryRecord = {
  id: number;
  profileId: number;
  feedId?: number;
  cveId?: string;
  channel: Channel;
  status: DeliveryStatus;
  isTest: boolean;
  providerMessageId?: string;
  errorCode?: string;
  createdAt: string;
  updatedAt: string;
};
