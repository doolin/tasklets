Feature: User creates profile

  Profiles provide more background information for users.

  Scenario: User creates a new profile
    Given I am a new and authenicated user
    And is on the Create Profile page
    When the user fills out all the profile fields correctly
    And the user presses the "Create Profile" button
    Then the user is shown the page for the new profile
