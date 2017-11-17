Feature: Unsubscribe

  Our emails might get annoying for some users,
  so there should always be an option for unsubscribing.

  Scenario: Unsubscribing
    Given I am a paying user
    When I visit the unsubscribe page
    Then I should be unsubscribed
