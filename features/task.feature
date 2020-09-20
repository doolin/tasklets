Feature: User manages tasks

  Scenario: Logged in user adds a task
    Given I am signed in
    And on the new task page
    # Then show me the page
    And I fill in the "Description" with "Task"
    And I fill in the "Label" with "label"
    When I press button "Create Task"
    Then I see message "Task was successfully created."

  @wip
  Scenario: Logged in user deletes a task
    Given I am signed in
    And on a specific task's page
    When I press "Delete Task"
    Then I should on my tasks list page
    And I should see "Task was successfully deleted."

