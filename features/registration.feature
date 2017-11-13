Feature: Registration

  Registration is crucial to our system. Users can't use
  the system without registering first, so it needs to
  be polished.

  Scenario: Successful Registration
    Given the mail delivery service works
    When I try to register with "shime@twobucks.co"
    Then I should receive a registration email
    And there should be 1 registered user

  Scenario: Registration Confirmation
    Given I am unregistered user
    And I go to registration confirmation URL
    Then I should become a paying user

  Scenario: Unsuccessful Registration - email taken
    Given a user with email "shime@twobucks.co" exists
    And the mail delivery service works
    When I try to register with "shime@twobucks.co" via API
    Then server response status should be 409

  Scenario: Unsuccessful Registration - mail delivery failed
    Given there are some issues with mail delivery service
    When I try to register with "shime@twobucks.co"
    Then there should be 0 registered users
