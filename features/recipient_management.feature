Feature: Recipient management
  As an application manager
  I want to manage the recipients who receive vulnerability notifications
  So that the right stakeholders stay informed

  Scenario: Application manager adds a new recipient
    Given I am logged in as an application manager
    When I add a recipient with valid information
    Then the recipient is saved
    And the recipient's information is stored in a GDPR friendly way

  Scenario: Application manager edits an existing recipient
    Given a recipient already exists
    And I am logged in as an application manager
    When I update that recipient's information
    Then the recipient's information is updated
    And the recipient's information remains stored in a GDPR friendly way

  Scenario: Application manager removes a recipient
    Given a recipient already exists
    And I am logged in as an application manager
    When I remove that recipient
    Then the recipient no longer receives notifications
    And the recipient's information is removed in line with GDPR requirements

  Scenario: Non-manager cannot manage recipients
    Given I am not logged in as an application manager
    When I attempt to add, edit, or remove a recipient
    Then the action is denied
