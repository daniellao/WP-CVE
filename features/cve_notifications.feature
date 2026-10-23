Feature: CVE vulnerability notifications
  As a recipient subscribed to WP CVE
  I want to be notified when a WordPress vulnerability is publicly disclosed
  So that I can respond to the risk in a timely manner

  Background:
    Given WP CVE is monitoring the CVE API for disclosed WordPress vulnerabilities

  Rule: A CVE that arrives on a CVE feed is relevant to the recipient profiles assigned to it, unless it has already been reported on that CVE feed

    @REQ-010 @PUC-3
    Scenario: A new publicly disclosed vulnerability triggers a notification
      Given a CVE feed configured with a CPE name for WordPress
      And a recipient profile assigned to that CVE feed
      And a new CVE matching that feed's CPE name has been publicly disclosed
      When WP CVE polls that CVE feed
      Then a vulnerability notification is sent to every recipient profile assigned to that feed

    @REQ-011 @PUC-3
    Scenario: A disclosed vulnerability matching no configured feed sends no notification
      Given a new CVE affecting WordPress has been publicly disclosed
      And the CVE does not match the CPE name of any configured CVE feed
      When WP CVE polls its CVE feeds
      Then no vulnerability notification is sent

  Rule: A CVE is reported to the recipient profiles of a CVE feed only once, also when its delivery fails

    @REQ-012 @PUC-3
    Scenario: The same vulnerability is not reported twice
      Given a CVE has already been reported to the recipient profiles of a CVE feed
      When WP CVE re-polls that feed and finds the same CVE
      Then no duplicate notification is sent to those recipient profiles

    @REQ-053 @PUC-3
    Scenario: A CVE whose delivery failed is not sent again
      Given a vulnerability notification about a CVE failed to deliver to a recipient profile of a CVE feed
      When WP CVE re-polls that feed and finds the same CVE
      Then no vulnerability notification about that CVE is sent again

  Rule: A recipient profile assigned to a CVE feed after its first poll receives only CVE that the feed finds in later polls

    @REQ-032 @PUC-3
    Scenario: A newly assigned recipient profile receives no earlier CVE
      Given a CVE feed that WP CVE has polled
      And a recipient profile is assigned to that CVE feed after that poll
      When WP CVE polls that CVE feed and finds a CVE that has not been reported to its recipient profiles
      Then a vulnerability notification about that CVE is sent to the newly assigned recipient profile
      And no vulnerability notification is sent to it about CVE reported before the assignment
