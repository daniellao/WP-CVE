Feature: CVE feed management
  As an application manager
  I want to configure CVE feeds and assign recipient profiles to them
  So that the right recipients are notified about the products we run

  Rule: A CVE feed holds exactly one CPE name, which is the only place a product is configured

    @REQ-004 @PUC-2
    Scenario: Application manager creates a CVE feed
      Given I am logged in as an application manager
      When I create a CVE feed with a valid CPE name
      Then the CVE feed is saved
      And the CVE feed watches the CVE API for CVE matching that CPE name

  Rule: A change of the CPE name of a CVE feed makes its next poll a first poll for the new CPE name

    @REQ-039 @PUC-2
    Scenario: Application manager changes the CPE name of a CVE feed
      Given a CVE feed that WP CVE has polled
      And I am logged in as an application manager
      When I change the CPE name of that CVE feed to a valid CPE name for another WordPress version
      Then the CVE feed is saved with the new CPE name

    @REQ-059 @PUC-3
    Scenario: The first poll after a change of the CPE name reports every matching CVE
      Given the CPE name of a CVE feed has been changed
      When WP CVE polls that CVE feed for the first time after the change
      Then a vulnerability notification is sent for every CVE that matches the new CPE name and has not been reported on that CVE feed

  Rule: A CPE name consists of 13 colon separated values, starting with "cpe" and "2.3", whose part, vendor, product and version components are not "*"

    @REQ-024 @PUC-2
    Scenario: A CPE name that does not consist of 13 colon separated values is rejected
      Given I am logged in as an application manager
      When I create a CVE feed with a CPE name that does not consist of 13 colon separated values
      Then the CVE feed is not saved
      And I am told that a CPE name consists of 13 colon separated values

    @REQ-025 @PUC-2
    Scenario: A CPE name that does not start with "cpe" and "2.3" is rejected
      Given I am logged in as an application manager
      When I create a CVE feed with a CPE name whose first two values are not "cpe" and "2.3"
      Then the CVE feed is not saved
      And I am told that a CPE name starts with "cpe" and "2.3"

    @REQ-005 @PUC-2
    Scenario: A CPE name with wildcard required components is rejected
      Given I am logged in as an application manager
      When I create a CVE feed with a CPE name whose part, vendor, product, or version component is "*"
      Then the CVE feed is not saved
      And I am told that the part, vendor, product, and version components are required

  Rule: A CVE feed is assigned at most two recipient profiles, and at least one while it is not suspended

    @REQ-006 @PUC-2
    Scenario: A CVE feed must have at least one recipient profile
      Given I am logged in as an application manager
      When I create a CVE feed without assigning a recipient profile
      Then the CVE feed is not saved
      And I am told that a new CVE feed must be assigned a recipient profile

    @REQ-007 @PUC-2
    Scenario: A second recipient profile can be assigned to a CVE feed
      Given a CVE feed with one assigned recipient profile
      And I am logged in as an application manager
      When I assign a second recipient profile to that CVE feed
      Then the second recipient profile is assigned to the CVE feed

    @REQ-008 @PUC-2
    Scenario: A third recipient profile is rejected
      Given a CVE feed with two assigned recipient profiles
      And I am logged in as an application manager
      When I assign a third recipient profile to that CVE feed
      Then the assignment is rejected
      And I am told that a CVE feed is limited to 2 recipient profiles

  Rule: A CVE feed whose only recipient profile is removed is suspended and is not polled until a recipient profile is assigned to it

    @REQ-051 @PUC-2
    Scenario: A suspended CVE feed resumes when a recipient profile is assigned
      Given a suspended CVE feed
      And I am logged in as an application manager
      When I assign a recipient profile to that CVE feed
      Then the CVE feed is no longer suspended

    @REQ-052 @PUC-3
    Scenario: A suspended CVE feed is not polled
      Given a suspended CVE feed
      When the scheduled time to poll the CVE feeds is reached
      Then WP CVE does not poll that CVE feed

  Rule: CVE modified while a CVE feed is suspended are recorded as reported without being sent, unless the next poll is a first poll after a change of its CPE name

    @REQ-057 @PUC-3
    Scenario: CVE of the suspension period are not sent after a CVE feed resumes
      Given a CVE feed that has resumed after a suspension
      And a CVE matching its CPE name was modified during the suspension
      When WP CVE polls that CVE feed
      Then no vulnerability notification about that CVE is sent
      And the CVE is recorded as reported on that CVE feed

    @REQ-066 @PUC-3
    Scenario: A CPE name change during a suspension leads to a first poll after the CVE feed resumes
      Given the CPE name of a suspended CVE feed has been changed
      And a recipient profile has been assigned to that CVE feed
      When WP CVE polls that CVE feed
      Then a vulnerability notification is sent for every CVE that matches the new CPE name and has not been reported on that CVE feed

  Rule: Only an application manager manages CVE feeds

    @REQ-040 @PUC-2
    Scenario: Non-manager cannot manage CVE feeds
      Given I am not logged in as an application manager
      When I attempt to create a CVE feed, change its CPE name, or assign a recipient profile to it
      Then the action is denied

  Rule: WP CVE pages through the results of each CVE API request with startIndex and resultsPerPage until all results of that request have been retrieved

    @REQ-009 @PUC-3
    Scenario: A CVE feed pages through a large collection of CVE
      Given a CVE feed whose CPE name matches more CVE than fit in a single response
      When WP CVE polls that CVE feed
      Then WP CVE pages through the collection using startIndex and resultsPerPage
      And every CVE in the collection is considered for notification

  Rule: The first poll of a CVE feed reports every CVE that matches its CPE name and has not been reported on that CVE feed

    @REQ-027 @PUC-3
    Scenario: The first poll of a new CVE feed reports every matching CVE
      Given a new CVE feed with a CPE name for the WordPress version in use
      And a recipient profile assigned to that CVE feed
      When WP CVE polls that CVE feed for the first time
      Then a vulnerability notification is sent for every CVE that matches the CPE name

  Rule: After the first poll, a poll of a CVE feed requests only the CVE modified since the last CVE received, using lastModStartDate and lastModEndDate in consecutive ranges of no more than 120 days

    @REQ-037 @PUC-3
    Scenario: A later poll requests only modified CVE
      Given a CVE feed that WP CVE has polled
      When WP CVE polls that CVE feed again
      Then the request is limited with lastModStartDate and lastModEndDate to the CVE modified since the last CVE received

    @REQ-058 @PUC-3
    Scenario: A period longer than 120 days is requested in consecutive ranges
      Given a CVE feed whose last CVE received was modified more than 120 days ago
      When WP CVE polls that CVE feed
      Then the period since that CVE is requested in consecutive ranges of no more than 120 days

  Rule: WP CVE polls each CVE feed that is not suspended every two hours

    @REQ-028 @PUC-3
    Scenario: A CVE feed is polled again after two hours
      Given a CVE feed that WP CVE has polled
      When two hours have passed since that poll
      Then WP CVE polls that CVE feed again

  Rule: WP CVE sends no more than 5 CVE API requests within any period of less than 30 seconds, with at least 6 seconds between two requests

    @REQ-031 @PUC-3
    Scenario: CVE API requests stay within the rate limit
      Given a CVE feed whose results span several pages
      When WP CVE polls that CVE feed
      Then no more than 5 CVE API requests are sent within any period of less than 30 seconds
      And at least 6 seconds pass between two consecutive CVE API requests

  Rule: A failed CVE API request is retried every 6 seconds, up to 10 attempts in total, and the next poll covers the period of an abandoned poll

    @REQ-029 @PUC-3
    Scenario: A failed CVE API request is retried
      Given the CVE API does not answer a request successfully
      When WP CVE polls a CVE feed
      Then WP CVE retries the request every 6 seconds
      And WP CVE stops after 10 attempts in total

    @REQ-038 @PUC-3
    Scenario: A poll abandoned after 10 failed attempts loses no CVE
      Given a later poll of a CVE feed was abandoned after 10 failed attempts
      When WP CVE polls that CVE feed at the next scheduled time
      Then the request covers the CVE modified since the last CVE received before the abandoned poll

    @REQ-067 @PUC-3
    Scenario: The poll after an abandoned first poll is again a first poll
      Given the first poll of a CVE feed was abandoned after 10 failed attempts
      When WP CVE polls that CVE feed at the next scheduled time
      Then that poll is a first poll and requests every CVE that matches the CPE name

  Rule: Every failed CVE API request is recorded in the error log

    @REQ-030 @PUC-3
    Scenario: A failed CVE API request is logged
      Given the CVE API does not answer a request successfully
      When WP CVE polls a CVE feed
      Then an error log entry is created for each failed attempt
