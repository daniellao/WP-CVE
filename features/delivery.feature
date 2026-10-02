Feature: Notification delivery via email and SMS
  As a recipient
  I want to receive vulnerability notifications through email or SMS
  So that I am reliably and promptly informed

  Rule: A vulnerability notification is delivered via the dedicated email and SMS services, over the channels the recipient profile is subscribed to

    @REQ-013 @PUC-3
    Scenario: Notification delivered by email
      Given a recipient profile with an email address on file
      And that recipient profile is subscribed to receive email notifications
      When a vulnerability notification is sent to that recipient profile
      Then the notification is delivered via the dedicated email service
      And a delivery record is written to the audit log

    @REQ-014 @PUC-3
    Scenario: Notification delivered by SMS
      Given a recipient profile with a phone number on file
      And that recipient profile is subscribed to receive SMS notifications
      When a vulnerability notification is sent to that recipient profile
      Then the notification is delivered via the dedicated SMS service
      And a delivery record is written to the audit log

  Rule: A failed delivery is recorded in the audit log for human inspection

    @REQ-015 @PUC-3
    Scenario: Email delivery failure is recorded
      Given a recipient profile with an email address on file
      When a vulnerability notification fails to deliver via the email service
      Then the failure is recorded in the audit log for human inspection
