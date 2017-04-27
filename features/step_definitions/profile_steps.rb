
# frozen_string_literal: true

# * http://benmabey.com/2008/05/19/imperative-vs-declarative-scenarios-in-user-stories.html
# * http://dannorth.net/2011/01/31/whose-domain-is-it-anyway/
# * http://elabs.se/blog/15-you-re-cuking-it-wrong

require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'support', 'paths'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'support', 'selectors'))

Given /^I am not authenticated$/ do
  visit('/users/sign_out') # ensure that at least
end

Given /^I have one\s+user "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  User.new(email: email,
           password: password,
           password_confirmation: password).save!
end

Given /^I am a new and authenicated user$/ do
  email = 'testing@man.net'
  password = 'secretpass'

  step %{I have one user "#{email}" with password "#{password}"}
  step %{I go to sign in}
  step %{I fill in "user_email" with "#{email}"}
  step %{I fill in "user_password" with "#{password}"}
  step %{I press "Sign in"}
end

Given /^is on the Create Profile page$/ do
  visit new_profile_path
end

# Date and time gem: https://gist.github.com/558786
When /^the user fills out all the profile fields correctly$/ do
  firstname = 'Foo'
  lastname  = 'Bar'
  # startdate = "2011-07-16"
  # finishdate = "2011-02-03 00:00:00.000000"
  bio = "Foo Bar's bio summary"
  step %{I fill in "Firstname" with "#{firstname}"}
  step %{I fill in "Lastname" with "#{lastname}"}
  step %{I fill in "Bio" with "#{bio}"}

  # Time and date fields are broken in Capybara, or
  # perhaps it's more accurate to say that Rails doesn't
  # implement something easily used for matching. Also,
  # HTML 5 is coming with it's own date/time form element.
  # Widespread adoption may be a few years in the future.
  # For now, getting the project to work correctly requires
  # removing the presence requirement of dates.
  # select(value, :from => field)
  # select_date("July 16, 2011", :from => 'Startdate')
  # And %{I select "#{startdate}" from "Startdate"}
  # And %{I select #{finishdate} from "Finishdate"}
end

When /^the user presses the "([^"]*)" button$/ do |button|
  click_button(button)
end

Then /^the user is shown the page for the new profile$/ do
  visit profile_path(1)
end

Then /^the member is shown the page for the new project$/ do
  # Fixme: the url needs to be extracted from the data
  visit ('new-project')
end
