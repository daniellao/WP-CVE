Feature: Delivery audit log
  As an application manager
  I want to inspect a log of notification delivery attempts
  So that I can verify recipients were reached and investigate problems

  Scenario: Successful delivery is logged
    Given a vulnerability notification has been sent to a recipient
    When the notification is delivered successfully
    Then an audit log entry is created showing a successful delivery

  Scenario: Failed delivery is logged
    Given a vulnerability notification has been sent to a recipient
    When the notification fails to deliver
    Then an audit log entry is created showing a failed delivery

  Scenario: Application manager inspects the audit log
    Given I am logged in as an application manager
    And there are delivery records in the audit log
    When I open the audit log
    Then I can see the delivery status of past notifications for human inspection
