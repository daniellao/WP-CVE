const postmarkEmailUrl = 'https://api.postmarkapp.com/email';
const requestTimeoutMilliseconds = 10_000;

export type PostmarkConfig = {
  serverToken: string;
  senderAddress: string;
};

export type EmailMessage = {
  to: string;
  subject: string;
  textBody: string;
};

export type EmailSubmission =
  { isAccepted: true; messageId: string } | { isAccepted: false; httpStatus?: number; errorCode?: string };

type PostmarkResponse = {
  ErrorCode: number;
  MessageID?: string;
};

export function readPostmarkConfig(environment: NodeJS.ProcessEnv): PostmarkConfig {
  const serverToken = environment['POSTMARK_SERVER_TOKEN'];
  const senderAddress = environment['POSTMARK_SENDER_ADDRESS'];
  if (!serverToken || !senderAddress) {
    throw new Error('POSTMARK_SERVER_TOKEN and POSTMARK_SENDER_ADDRESS must be set.');
  }
  return { serverToken, senderAddress };
}

export async function sendEmail(config: PostmarkConfig, message: EmailMessage): Promise<EmailSubmission> {
  const response = await postEmail(config, message).catch(() => undefined);
  if (!response) {
    return { isAccepted: false };
  }

  const body: unknown = await response.json().catch(() => undefined);
  if (!isPostmarkResponse(body)) {
    return { isAccepted: false, httpStatus: response.status };
  }
  if (response.ok && body.ErrorCode === 0 && body.MessageID) {
    return { isAccepted: true, messageId: body.MessageID };
  }
  return { isAccepted: false, httpStatus: response.status, errorCode: String(body.ErrorCode) };
}

function postEmail(config: PostmarkConfig, message: EmailMessage): Promise<Response> {
  return fetch(postmarkEmailUrl, {
    method: 'POST',
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
      'X-Postmark-Server-Token': config.serverToken,
    },
    body: JSON.stringify({
      From: config.senderAddress,
      To: message.to,
      Subject: message.subject,
      TextBody: message.textBody,
      MessageStream: 'outbound',
      TrackOpens: false,
      TrackLinks: 'None',
    }),
    signal: AbortSignal.timeout(requestTimeoutMilliseconds),
  });
}

function isPostmarkResponse(body: unknown): body is PostmarkResponse {
  if (typeof body !== 'object' || body === null || !('ErrorCode' in body)) {
    return false;
  }
  const messageId = 'MessageID' in body ? body.MessageID : undefined;
  return typeof body.ErrorCode === 'number' && (messageId === undefined || typeof messageId === 'string');
}
