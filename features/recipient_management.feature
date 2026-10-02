Feature: Recipient management
  As an application manager
  I want to manage the recipient profiles of the people who receive vulnerability notifications
  So that the right stakeholders stay informed

  @REQ-016 @PUC-1
  Scenario: Application manager adds a new recipient profile
    Given I am logged in as an application manager
    When I add a recipient profile with valid information
    Then the recipient profile is saved
    And the recipient's information is stored in a GDPR friendly way

  @REQ-017 @PUC-1
  Scenario: Application manager edits an existing recipient profile
    Given a recipient profile already exists
    And I am logged in as an application manager
    When I update that recipient profile's information
    Then the recipient profile's information is updated
    And the recipient's information remains stored in a GDPR friendly way

  @REQ-018 @PUC-1
  Scenario: Application manager removes a recipient profile
    Given a recipient profile already exists
    And I am logged in as an application manager
    When I remove that recipient profile
    Then the recipient no longer receives notifications
    And the recipient's information is removed in line with GDPR requirements

  @REQ-019 @PUC-1
  Scenario: A recipient profile assigned to a CVE feed as its only profile cannot be removed
    Given a recipient profile that is the only profile assigned to a CVE feed
    And I am logged in as an application manager
    When I remove that recipient profile
    Then I am told that the CVE feed would be left without a recipient profile

  @REQ-020 @PUC-1
  Scenario: Non-manager cannot manage recipient profiles
    Given I am not logged in as an application manager
    When I attempt to add, edit, or remove a recipient profile
    Then the action is denied
