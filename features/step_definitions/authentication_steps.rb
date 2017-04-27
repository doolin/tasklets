
# frozen_string_literal: true

# Session
Given /^that a confirmed user exists$/ do
  # Given %{I have one user "minimal@example.com" with password "test1234"}
  step %{I have one user "minimal@example.com" with password "test1234"}
end

Given /^I am logged in$/ do
  visit path_to('the login page')
  fill_in('user_email', with: @user.email)
  fill_in('user_password', with: @user.password)
  click_button('Sign in')
  if defined?(Spec::Rails::Matchers)
    page.should have_content('Signed in successfully')
  else
    assert page.has_content?('Signed in successfully')
  end
end
