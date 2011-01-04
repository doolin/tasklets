Feature: User manages tasks

  Scenario: Logged in user adds a task
    Given I am on the new task page
    #Then show me the page
    And I fill in the "Description" with "Task"
    When I press "Create Task" 
    Then I should be on the page for that task
    And I should see "Started" checkbox

