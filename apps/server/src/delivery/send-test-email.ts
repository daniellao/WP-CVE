import { readPostmarkConfig, sendEmail } from './postmark.ts';

const recipient = process.env['TEST_EMAIL_RECIPIENT'];
if (!recipient) {
  throw new Error('TEST_EMAIL_RECIPIENT must be set.');
}

const submission = await sendEmail(readPostmarkConfig(process.env), {
  to: recipient,
  subject: 'WP CVE test email',
  textBody: 'This email confirms that WP CVE can send email through Postmark.',
});
console.log(submission);
