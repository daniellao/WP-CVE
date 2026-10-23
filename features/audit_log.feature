Feature: Delivery audit log and error log
  As an application manager
  I want to inspect a log of notification delivery attempts and a log of errors
  So that I can verify recipients were reached and investigate problems

  Rule: Every delivery attempt of a vulnerability notification is recorded in the audit log with its delivery status

    @REQ-001 @PUC-3
    Scenario: A delivery attempt is logged with a pending delivery status
      Given a vulnerability notification for a recipient profile
      When the vulnerability notification is handed to the email service
      Then an audit log entry is created showing a pending delivery status

    @REQ-002 @PUC-3
    Scenario: A delivery attempt rejected by the email service is logged as failed
      Given a vulnerability notification for a recipient profile
      When the email service rejects the vulnerability notification
      Then an audit log entry is created showing a failed delivery

  Rule: The audit log and the error log are available to application managers for human inspection

    @REQ-003 @PUC-5
    Scenario: Application manager inspects the audit log
      Given I am logged in as an application manager
      And there are delivery records in the audit log
      When I open the audit log
      Then I can see the delivery status of past vulnerability notifications and test messages for human inspection

    @REQ-043 @PUC-5
    Scenario: Application manager inspects the error log
      Given I am logged in as an application manager
      And there are entries in the error log
      When I open the error log
      Then I can see the failed CVE API requests and failed deliveries for human inspection

  Rule: The audit log shows no delivery records of removed recipient profiles

    @REQ-054 @PUC-5
    Scenario: Delivery records of a removed recipient profile are not shown
      Given a recipient profile with delivery records has been removed
      And I am logged in as an application manager
      When I open the audit log
      Then no delivery records of that recipient profile are shown

  Rule: Only an application manager inspects the audit log and the error log

    @REQ-042 @PUC-5
    Scenario: Non-manager cannot inspect the audit log or the error log
      Given I am not logged in as an application manager
      When I attempt to open the audit log or the error log
      Then the action is denied
