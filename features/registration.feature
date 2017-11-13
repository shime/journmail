Feature: Registration

  Registration is crucial to our system. Users can't use
  the system without registering first, so it needs to
  be polished.

  Scenario: Successful Registration
    When I try to register with "shime@twobucks.co"
    Then I should receive a registration email
    And the new user should be created

  Scenario: Registration Confirmation
    Given I am unregistered user
    And I go to registration confirmation URL
    Then I should become a paying user

  Scenario: Unsuccessful Registration
    Given a user with email "shime@twobucks.co" exists
    When I try to register with "shime@twobucks.co" via API
    Then server response status should be 409
