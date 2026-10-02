Feature: Delivery audit log
  As an application manager
  I want to inspect a log of notification delivery attempts
  So that I can verify recipients were reached and investigate problems

  Rule: Every delivery attempt of a vulnerability notification is recorded in the audit log with its delivery status

    @REQ-001 @PUC-3
    Scenario: Successful delivery is logged
      Given a vulnerability notification has been sent to a recipient
      When the notification is delivered successfully
      Then an audit log entry is created showing a successful delivery

    @REQ-002 @PUC-3
    Scenario: Failed delivery is logged
      Given a vulnerability notification has been sent to a recipient
      When the notification fails to deliver
      Then an audit log entry is created showing a failed delivery

  Rule: The audit log is available to application managers for human inspection

    @REQ-003 @PUC-5
    Scenario: Application manager inspects the audit log
      Given I am logged in as an application manager
      And there are delivery records in the audit log
      When I open the audit log
      Then I can see the delivery status of past notifications for human inspection
