# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email 'david.doolin+3@example.com'
    password 'foobarquux'
    password_confirmation 'foobarquux'
  end

  factory :minimal_user, class: User do
    username 'minimal'
    email 'minimal@example.com'
    password 'test1234'
    password_confirmation 'test1234'
  end
end
