

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
  #puts "in the field %s fill in step value %s" % [field, value]
  fill_in(field, :with => value)
end

When(/^I pressem button "(.*?)"$/) do |arg1|
  click_button 'Create Task'
end

Then(/^I'ma get "(.*?)"$/) do |arg1|
  page.body.should have_selector '.flash.success', text: 'Task was successfully created.'
end
