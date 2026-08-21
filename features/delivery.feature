Feature: Notification delivery via email and SMS
  As a subscriber
  I want to receive vulnerability notifications through email or SMS
  So that I am reliably and promptly informed

  Scenario: Notification delivered by email
    Given a subscriber has an email address on file
    And that subscriber is subscribed to receive email notifications
    When a vulnerability notification is sent to that subscriber
    Then the notification is delivered via the dedicated email service
    And a delivery record is written to the audit log

  Scenario: Notification delivered by SMS
    Given a subscriber has a phone number on file
    And that subscriber is subscribed to receive SMS notifications
    When a vulnerability notification is sent to that subscriber
    Then the notification is delivered via the dedicated SMS service
    And a delivery record is written to the audit log

  Scenario: Email delivery failure is recorded
    Given a subscriber has an email address on file
    When a vulnerability notification fails to deliver via the email service
    Then the failure is recorded in the audit log for human inspection
