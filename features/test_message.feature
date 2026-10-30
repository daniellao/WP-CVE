Feature: Sending a test message
  As an application manager
  I want to send a test message to a recipient profile
  So that I can confirm its contact details and feed assignments before a real CVE arrives

  Rule: A test message is handed to the same email service and SMS service as a vulnerability notification, over every channel the recipient profile is subscribed to

    @REQ-021 @PUC-4
    Scenario: Test message is handed to the same services as a notification
      Given a recipient profile with an email address on file
      And that recipient profile is subscribed to receive email notifications
      And I am logged in as an application manager
      When I send a test message to that recipient profile
      Then the test message is handed to the email service

    @REQ-045 @PUC-4
    Scenario: Test message is handed to the SMS service
      Given a recipient profile with a phone number on file
      And that recipient profile is subscribed to receive SMS notifications
      And I am logged in as an application manager
      When I send a test message to that recipient profile
      Then the test message is handed to the SMS service

  Rule: A test message lists the CVE feeds the recipient profile is currently assigned to

    @REQ-022 @PUC-4
    Scenario: Test message lists the recipient profile's CVE feeds
      Given a recipient profile assigned to one or more CVE feeds
      And I am logged in as an application manager
      When I send a test message to that recipient profile
      Then the test message lists the CVE feeds that profile is currently assigned to

  Rule: A test message is written to the audit log and marked as a test

    @REQ-023 @PUC-4
    Scenario: Test message is logged and marked as a test
      Given a recipient profile with an email address on file
      And that recipient profile is subscribed to receive email notifications
      And I am logged in as an application manager
      When I send a test message to that recipient profile
      Then a delivery record is written to the audit log
      And the audit log entry is marked as a test message

  Rule: The delivery status of a test message is updated from the delivery report, and a failed test message is recorded in the error log

    @REQ-046 @PUC-4
    Scenario: A failed test message is recorded
      Given I am logged in as an application manager
      And I have sent a test message that was handed to the email service
      When the email service sends a delivery report showing a failed delivery
      Then the audit log entry of the test message shows a failed delivery
      And an error log entry is created for the failed delivery

    @REQ-065 @PUC-4
    Scenario: A successful test message by SMS is recorded
      Given I am logged in as an application manager
      And I have sent a test message that was handed to the SMS service
      When the SMS service sends a delivery report showing a successful delivery
      Then the audit log entry of the test message shows a successful delivery

  Rule: Only an application manager sends test messages

    @REQ-041 @PUC-4
    Scenario: Non-manager cannot send a test message
      Given I am not logged in as an application manager
      When I attempt to send a test message to a recipient profile
      Then the action is denied
