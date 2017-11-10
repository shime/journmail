Feature: Billing

  We want to have billing in order to have a sustainable business.

  Scenario: Scheduling Next Payment
    Given I am unregistered user
    When I register with my email
    Then I should receive a registration email
    And the next payment should be scheduled for 30 days and should be 2$
    And I should become a paying user

  Scenario: Payment Reminder Email
    Given I am a paying user
    When I haven't payed for 30 days
    Then I should receive an email to pay

  Scenario: Payment Notification
    Given I am a paying user
    When I haven't payed for 30 days
    When I go to a history page
    Then I should see a notification that I should pay

