Feature: User manages tasks

  Scenario: Logged in user adds a task
    Given I am signed in
    And on the new task page
    #Then show me the page
    And I fill in the "Description" with "Task"
    When I press "Create Task"
    Then I should see "Task was successfully created."

