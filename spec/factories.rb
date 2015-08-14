FactoryGirl.define do
  factory :task do
    description 'Task description dummy text.'
  end

  factory :user do
    email                 'david.doolin+3@example.com'
    password              'foobarquux'
    password_confirmation 'foobarquux'
  end
end
