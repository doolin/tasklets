# frozen_string_literal: true

FactoryGirl.define do
  factory :task do
    description 'Task description dummy text.'
    association :user
  end
end
