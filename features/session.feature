Feature: Session handling
  In order to use the site
  As a registered user
  I need to be able to login and logout

Background:
  Given that a confirmed user exists

Scenario Outline: Logging in
  Given I am on the sign in page
  When I fill in "user_email" with "<email>"
  And I fill in "user_password" with "<password>"
  And I press "Sign in"
  Then I should <action>
  Examples:
    |         email       |  password   |              action             |
    | minimal@example.com |  test1234   | see "Signed in successfully"    |
    | bad@example.com     |  password   | see "Invalid email or password" |

Scenario: Logging out
  Given I am signed in
  When I sign out
  Then I should see "You need to sign in or sign up before continuing."
