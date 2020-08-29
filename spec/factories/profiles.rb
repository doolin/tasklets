# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    firstname { 'myrcella' }
    association :user
  end
end
