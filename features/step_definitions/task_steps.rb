

# Steps for task

Given /^I am signed in$/ do
  email = 'testing@man.net'
  password = 'secretpass'

  step %{I have one user "#{email}" with password "#{password}"}
  step %{I go to sign in}
  step %{I fill in "user_email" with "#{email}"}
  step %{I fill in "user_password" with "#{password}"}
  step %{I press "Sign in"}
end

Given /^on the new task page$/ do
  visit new_task_path
end


Given /^I fill in the "([^"]*)" with "([^"]*)"$/ do |field, value|
  fill_in(field, :with => value) # pending # express the regexp above with the code you wish you had
end


