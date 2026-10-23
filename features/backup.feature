Feature: Backup and restore
  As a system administrator
  I want to restore WP CVE from a backup
  So that WP CVE recovers from data loss without bringing back removed personal data

  Rule: Backups are encrypted and kept for 30 days, and a restore from a backup does not bring back a removed recipient profile

    @REQ-047 @PUC-6
    Scenario: A restore does not bring back a removed recipient profile
      Given a recipient profile was removed after a backup was made
      When I restore WP CVE from that backup
      Then the removed recipient profile is not restored

    @REQ-061 @PUC-6
    Scenario: A backup is destroyed after 30 days
      Given a backup of WP CVE
      When 30 days have passed since that backup was made
      Then that backup no longer exists
      And the personal data of recipient profiles removed since that backup no longer exists in any backup

    @REQ-063 @PUC-6
    Scenario: A backup is encrypted
      Given a backup of WP CVE
      When the backup is read without the backup encryption key
      Then no contact details of a recipient profile can be read from it

  Rule: Only a system administrator restores WP CVE from a backup

    @REQ-064 @PUC-6
    Scenario: An application manager cannot restore WP CVE from a backup
      Given I am logged in as an application manager
      When I attempt to restore WP CVE from a backup
      Then the action is denied
