Feature: Sending a test message
  As an application manager
  I want to send a test message to a recipient profile
  So that I can confirm its contact details and feed assignments before a real CVE arrives

  Rule: A test message is delivered over the same email and SMS services as a vulnerability notification

    @REQ-021 @PUC-4
    Scenario: Test message is delivered over the same services as a notification
      Given a recipient profile with an email address on file
      And I am logged in as an application manager
      When I send a test message to that recipient profile
      Then the test message is delivered via the dedicated email service

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
      And I am logged in as an application manager
      When I send a test message to that recipient profile
      Then a delivery record is written to the audit log
      And the audit log entry is marked as a test message
