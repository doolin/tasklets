

# Steps for task

Given /^I am signed in$/ do
  email = 'testing@man.net'
  password = 'secretpass'

  Given %{I have one user "#{email}" with password "#{password}"}
  And %{I go to sign in}
  And %{I fill in "user_email" with "#{email}"}
  And %{I fill in "user_password" with "#{password}"}
  And %{I press "Sign in"}
end

Given /^on the new task page$/ do
  visit new_task_path
end


Given /^I fill in the "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value) # pending # express the regexp above with the code you wish you had
end


