Feature: Scale Development and Credit Management

  Background:
    # Set up a test user with a known credit balance
    Given a user named "Test User" exists
    And the user's initial credit balance is 50

  Scenario: Successful Scale Creation with Sufficient Credit
    Given the scale creation cost is 15 credits
    When "Test User" attempts to create a scale named "New Scale"
    Then the HTTP response code should be 201 (Created)
    And "Test User"'s new credit balance should be 35
    And a Credit Transaction record of "ScaleDevelopment" should be created in the system

  Scenario: Failed Scale Creation with Insufficient Credit
    Given a user named "Poor User" exists
    And the user's initial credit balance is 5
    And the scale creation cost is 15 credits
    When "Poor User" attempts to create a scale
    Then the HTTP response code should be 402 (Payment Required)
    And "Poor User"'s credit balance should remain unchanged (5)
    And no new Credit Transaction record should be created in the system