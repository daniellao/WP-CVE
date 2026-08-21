Feature: Subscriber management
  As an application manager
  I want to manage the subscribers who receive vulnerability notifications
  So that the right stakeholders stay informed

  Scenario: Application manager adds a new subscriber
    Given I am logged in as an application manager
    When I add a subscriber with valid recipient information
    Then the subscriber is saved
    And the subscriber's recipient information is stored in a GDPR friendly way

  Scenario: Application manager edits an existing subscriber
    Given a subscriber already exists
    And I am logged in as an application manager
    When I update that subscriber's recipient information
    Then the subscriber's information is updated
    And the subscriber's recipient information remains stored in a GDPR friendly way

  Scenario: Application manager removes a subscriber
    Given a subscriber already exists
    And I am logged in as an application manager
    When I remove that subscriber
    Then the subscriber no longer receives notifications
    And the subscriber's recipient information is removed in line with GDPR requirements

  Scenario: Non-manager cannot manage subscribers
    Given I am not logged in as an application manager
    When I attempt to add, edit, or remove a subscriber
    Then the action is denied
