# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    description { 'Task description dummy text.' }
    association :user
  end
end
