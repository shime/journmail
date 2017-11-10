Feature: Daily Streaks

  We want to keep track of users streaks so it can motivate them and they can
  share it with their friends.

  Scenario: Incrementing Streaks
    Given I am a paying user
    When I add a new log entry
    Then my daily streak should increment by one

  Scenario: Streak Zero
    Given I am a paying user
    When I log entries for two consecutive days
    And I don't log anything on a third day
    Then my daily streak should be zero
    And my longest streak should be two
