Feature: CVE feed management
  As an application manager
  I want to configure CVE feeds and assign recipient profiles to them
  So that the right recipients are notified about the products we run

  @REQ-004 @PUC-2
  Scenario: Application manager creates a CVE feed
    Given I am logged in as an application manager
    When I create a CVE feed with a valid CPE name
    Then the CVE feed is saved
    And the CVE feed watches the CVE API for CVE matching that CPE name

  @REQ-005 @PUC-2
  Scenario: A CPE name with wildcard required components is rejected
    Given I am logged in as an application manager
    When I create a CVE feed with a CPE name whose part, vendor, product, or version component is "*"
    Then the CVE feed is not saved
    And I am told that the part, vendor, product, and version components are required

  @REQ-006 @PUC-2
  Scenario: A CVE feed must have at least one recipient profile
    Given I am logged in as an application manager
    When I create a CVE feed without assigning a recipient profile
    Then the CVE feed is not saved
    And I am told that every CVE feed must be assigned a recipient profile

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

  @REQ-009 @PUC-3
  Scenario: A CVE feed pages through a large collection of CVE
    Given a CVE feed whose CPE name matches more CVE than fit in a single response
    When WP CVE polls that CVE feed
    Then WP CVE pages through the collection using startIndex and resultsPerPage
    And every CVE in the collection is considered for notification
