Feature: Emails

  Emails play a central role in our system, we use them as a
  notification system and for registration.

  In order to train consistency, we notify users every day in the evening that they
  should write a new entry for their day (one sentence).

  Scenario: Registration
    Given I am unregistered user
    When I register with my email
    Then I should receive a registration email

  Scenario: Registration Confirmation
    Given I am a paying user
    And I have received registration email
    When I click on "confirm subscription" button
    Then I should become a paying user

  Scenario: Notification Emails
    Given I am a paying user
    When time is 20:00 in my timezone
    Then I should receive an email notification

  Scenario: Email Replies
    Given I am a paying user
    And I've received an email notification
    When I respond to email notification
    Then a new log entry should be created
