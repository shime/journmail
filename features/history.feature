Feature: History

  We want to keep a history of entries so users can read them later.

  Scenario: Viewing History
    Given I am a paying user
    And I have 10 entries
    When I go to a history page
    Then I should see 10 entries
