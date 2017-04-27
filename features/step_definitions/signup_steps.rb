
# frozen_string_literal: true

# Given /^that a confirmed user exists$/ do
#  pending # express the regexp above with the code you wish you had
# end

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end
