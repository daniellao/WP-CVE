Feature: Notification delivery via email and SMS
  As a recipient
  I want to receive vulnerability notifications through email or SMS
  So that I am reliably and promptly informed

  Rule: A vulnerability notification is handed to the email service and the SMS service, over the channels the recipient profile is subscribed to

    @REQ-013 @PUC-3
    Scenario: Notification handed to the email service
      Given a recipient profile with an email address on file
      And that recipient profile is subscribed to receive email notifications
      When a vulnerability notification is sent to that recipient profile
      Then the vulnerability notification is handed to the email service

    @REQ-014 @PUC-3
    Scenario: Notification handed to the SMS service
      Given a recipient profile with a phone number on file
      And that recipient profile is subscribed to receive SMS notifications
      When a vulnerability notification is sent to that recipient profile
      Then the vulnerability notification is handed to the SMS service

  Rule: A failed delivery is recorded in the audit log and the error log, and is not retried

    @REQ-015 @PUC-3
    Scenario: Email delivery failure is recorded
      Given a vulnerability notification has been handed to the email service
      When the delivery report of the email service shows a failed delivery
      Then the failure is recorded in the audit log for human inspection
      And an error log entry is created for the failed delivery
      And the delivery is not retried

    @REQ-034 @PUC-3
    Scenario: SMS delivery rejection is recorded
      Given a vulnerability notification for a recipient profile
      When the SMS service rejects the vulnerability notification
      Then the failure is recorded in the audit log for human inspection
      And an error log entry is created for the failed delivery
      And the delivery is not retried

  Rule: The delivery status is updated from the delivery report of the email or SMS service

    @REQ-033 @PUC-3
    Scenario: A delivery report updates the delivery status
      Given a vulnerability notification has been handed to the email service
      And its delivery record shows a pending delivery status
      When the email service sends a delivery report for that notification
      Then the delivery record shows the delivery status from the delivery report

    @REQ-044 @PUC-3
    Scenario: A delivery report of the SMS service updates the delivery status
      Given a vulnerability notification has been handed to the SMS service
      And its delivery record shows a pending delivery status
      When the SMS service sends a delivery report showing a failed delivery
      Then the delivery record shows a failed delivery status
