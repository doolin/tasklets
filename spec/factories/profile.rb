# frozen_string_literal: true

FactoryGirl.define do
  factory :profile do
    firstname 'myrcella'
    association :user
  end
end
