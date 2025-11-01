Feature: Survey and Response Management (Nested Resources)

  Background:
    Given a user named "Owner User" exists
    And the user's initial credit balance is 50
    And the scale creation cost is 15 credits
    And the survey creation cost is 8 credits
    And the data collection cost is 1 credits

  Scenario: Successful Survey Creation and Credit Deduction
    Given a scale named "Project Alpha" under the "Owner User" exists
    When "Owner User" creates a survey under the "Project Alpha" scale
    Then the HTTP response code should be 201 (Created)
    And "Owner User"'s new credit balance should be 42
    And a Credit Transaction record of "SurveyCreation" should be created in the system

Scenario: Successful Response Submission and Credit Deduction
  Given a user named "Collector User" exists
  And the user's initial credit balance is 42
  And a scale named "Data Project" under the "Collector User" exists
  
  # YENİ ÖN KOŞUL: Anketin zaten var olduğunu varsayıyoruz (bu kod kredi düşürmez)
  Given a survey named "Auto Survey" exists under the scale "Data Project"
  
  # Kaldirildi: And "Collector User" creates a survey under the "Data Project" scale <-- Bu adım kaldırılmalı!
  
  When a response is submitted for the "Auto Survey" survey
  Then the HTTP response code should be 202 (Accepted)
  And "Collector User"'s new credit balance should be 41
  And a Credit Transaction record of "DataCollection" should be created in the system