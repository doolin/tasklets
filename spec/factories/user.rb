FactoryGirl.define do
  factory :minimal_user, class: User do
    username 'minimal'
    email 'minimal@example.com'
    password 'test1234'
    password_confirmation 'test1234'
  end
end
