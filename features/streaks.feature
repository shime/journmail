Feature: Daily Streaks

  We want to keep track of users streaks so it can motivate them and they can
  share it with their friends.

  Scenario: Initial Streak
    Given I am a paying user
    Then my daily streak should be 0

  Scenario: Incrementing Streaks
    Given I am a paying user
    When I add a new log entry
    Then my daily streak should be 1

  Scenario: Streak Two
    Given I am a paying user
    When I log entries for 2 consecutive days
    Then my daily streak should be 2

  Scenario: Streak Zero
    Given I am a paying user
    When I log entries for 2 consecutive days
    And I don't log anything on a third day
    Then my daily streak should be 0
    And my longest streak should be 2

  Scenario: Streak Broken
    Given I am a paying user
    When I log entries for 2 consecutive days
    And I don't log anything on a third day
    And I log entries for 4 consecutive days
    Then my daily streak should be 4
