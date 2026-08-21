Feature: CVE vulnerability notifications
  As a stakeholder subscribed to WP CVE
  I want to be notified when a WordPress vulnerability is publicly disclosed
  So that I can respond to the risk in a timely manner

  Background:
    Given WP CVE is monitoring public sources for disclosed WordPress vulnerabilities

  Scenario: A new publicly disclosed vulnerability triggers a notification
    Given a new CVE affecting WordPress has been publicly disclosed
    And there are recipients relevant to that vulnerability
    When WP CVE detects the disclosed vulnerability
    Then a notification is sent to the relevant recipients
    And the notification is recorded in the audit log

  Scenario: A disclosed vulnerability with no relevant recipients does not send notifications
    Given a new CVE affecting WordPress has been publicly disclosed
    And there are no recipients relevant to that vulnerability
    When WP CVE detects the disclosed vulnerability
    Then no notification is sent

  Scenario: The same vulnerability is not reported twice
    Given a CVE has already been reported to relevant recipients
    When WP CVE re-scans public sources and finds the same CVE
    Then no duplicate notification is sent to those recipients
