Feature: Email Notifications

  In order to train consistency, we notify users every day in the evening that they
  should write a new entry for their day (one sentence).

  Scenario: Notification Emails
    Given I am a paying user
    When time is 20:00 in my timezone
    Then I should receive an email notification

  Scenario: Email Replies
    Given I am a paying user
    And I've received an email notification
    When I respond to email notification
    Then a new log entry should be created
