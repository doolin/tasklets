FactoryGirl.define do
  factory :task do
    description "Task description dummy text."
  end
end

FactoryGirl.define do
  factory :user do
    email                 "david.doolin+3@example.com"
    password              "foobar"
    password_confirmation "foobar"
  end
end
