Feature: CVE vulnerability notifications
  As a recipient subscribed to WP CVE
  I want to be notified when a WordPress vulnerability is publicly disclosed
  So that I can respond to the risk in a timely manner

  Background:
    Given WP CVE is monitoring the CVE API for disclosed WordPress vulnerabilities

  Scenario: A new publicly disclosed vulnerability triggers a notification
    Given a CVE feed configured with a CPE name for WordPress
    And a recipient profile assigned to that CVE feed
    And a new CVE matching that feed's CPE name has been publicly disclosed
    When WP CVE polls that CVE feed
    Then a notification is sent to every recipient profile assigned to that feed
    And the notification is recorded in the audit log

  Scenario: A disclosed vulnerability matching no configured feed sends no notification
    Given a new CVE affecting WordPress has been publicly disclosed
    And the CVE does not match the CPE name of any configured CVE feed
    When WP CVE polls its CVE feeds
    Then no notification is sent

  Scenario: The same vulnerability is not reported twice
    Given a CVE has already been reported to the recipient profiles of a CVE feed
    When WP CVE re-polls that feed and finds the same CVE
    Then no duplicate notification is sent to those recipient profiles
