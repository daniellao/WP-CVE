Feature: Recipient management
  As an application manager
  I want to manage the recipient profiles of the people who receive vulnerability notifications
  So that the right stakeholders stay informed

  Rule: A recipient profile is the record of one recipient, subscribed to at least one channel, holding an email address only when subscribed to email, a phone number only when subscribed to SMS, and no CPE name

    @REQ-026 @PUC-1
    Scenario: A recipient profile holds the contact details and channels of one recipient
      Given I am logged in as an application manager
      When I add a recipient profile with valid information
      And I confirm that the recipient gave consent by email to the helpdesk
      Then the recipient profile holds the subscribed channels of one recipient and the contact details for those channels
      And the recipient profile holds no CPE name

    @REQ-055 @PUC-1
    Scenario: A recipient profile without a subscribed channel is not saved
      Given I am logged in as an application manager
      When I add a recipient profile that is not subscribed to any channel
      Then the recipient profile is not saved
      And I am told that a recipient profile is subscribed to at least one channel

    @REQ-062 @PUC-1
    Scenario: Unsubscribing a recipient profile from its last channel is rejected
      Given a recipient profile subscribed only to email
      And I am logged in as an application manager
      When I unsubscribe that recipient profile from email
      Then the change is not saved
      And I am told to remove the recipient profile instead

  Rule: Recipient information is stored encrypted and removed completely

    @REQ-016 @PUC-1
    Scenario: Application manager adds a new recipient profile
      Given I am logged in as an application manager
      When I add a recipient profile with valid information
      And I confirm that the recipient gave consent by email to the helpdesk
      Then the recipient profile is saved
      And its contact details are stored encrypted

    @REQ-017 @PUC-1
    Scenario: Application manager unsubscribes a recipient profile from a channel
      Given a recipient profile subscribed to email and SMS
      And I am logged in as an application manager
      When I unsubscribe that recipient profile from SMS
      Then the change is saved without a new confirmation of consent
      And the phone number of that recipient profile is removed
      And its email address remains stored encrypted

    @REQ-018 @PUC-1
    Scenario: Application manager removes a recipient profile
      Given a recipient profile already exists
      And I am logged in as an application manager
      When I remove that recipient profile
      Then the recipient profile is removed
      And the recipient no longer receives vulnerability notifications

    @REQ-036 @PUC-1
    Scenario: Removing a recipient profile removes all of its personal data
      Given a recipient profile with delivery records and error log entries
      And I am logged in as an application manager
      When I remove that recipient profile
      Then its delivery records and error log entries are removed

  Rule: A recipient profile is saved, and its email address or phone number is changed, only when the application manager confirms the consent that the recipient gave by email to the helpdesk

    @REQ-035 @PUC-1
    Scenario: A recipient profile without confirmed consent is not saved
      Given I am logged in as an application manager
      When I add a recipient profile without confirming that the recipient gave consent by email to the helpdesk
      Then the recipient profile is not saved
      And I am told that the consent of the recipient has to be confirmed

    @REQ-048 @PUC-1
    Scenario: A changed email address without confirmed consent is not saved
      Given a recipient profile already exists
      And I am logged in as an application manager
      When I change its email address without confirming that the recipient gave consent by email to the helpdesk
      Then the change is not saved
      And I am told that the consent of the recipient has to be confirmed

    @REQ-060 @PUC-1
    Scenario: A changed phone number without confirmed consent is not saved
      Given a recipient profile already exists
      And I am logged in as an application manager
      When I change its phone number, or subscribe it to SMS with a new phone number, without confirming that the recipient gave consent by email to the helpdesk
      Then the change is not saved
      And I am told that the consent of the recipient has to be confirmed

  Rule: The confirmation of consent is recorded with its time and the confirming application manager

    @REQ-056 @PUC-1
    Scenario: The confirmation of consent is recorded
      Given I am logged in as an application manager
      When I add a recipient profile with valid information
      And I confirm that the recipient gave consent by email to the helpdesk
      Then the time of the confirmation and my identity are recorded with the recipient profile

  Rule: Removing the only recipient profile of a CVE feed suspends that CVE feed

    @REQ-050 @PUC-1
    Scenario: Removing the only recipient profile of a CVE feed suspends the CVE feed
      Given a recipient profile that is the only profile assigned to a CVE feed
      And I am logged in as an application manager
      When I remove that recipient profile
      Then the recipient profile is removed
      And the CVE feed is suspended
      And I am told that the CVE feed is suspended until a recipient profile is assigned to it

  Rule: Only an application manager manages recipient profiles

    @REQ-020 @PUC-1
    Scenario: Non-manager cannot manage recipient profiles
      Given I am not logged in as an application manager
      When I attempt to add, edit, or remove a recipient profile
      Then the action is denied
