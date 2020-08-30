# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    # SecureRandom.hex is a Ruby stdlib method, see
    # https://ruby-doc.org/stdlib-2.7.1/libdoc/securerandom/rdoc/SecureRandom.html
    # which is extended by
    # https://ruby-doc.org/stdlib-2.7.1/libdoc/securerandom/rdoc/Random/Formatter.html
    email { "foo.bar+#{SecureRandom.hex}@example.com" }
    password { 'foobarquux' }
    password_confirmation { 'foobarquux' }
  end

  factory :minimal_user, class: User do
    email { "minimal+#{SecureRandom.hex}@example.com" }
    password { 'test1234' }
    password_confirmation { 'test1234' }
  end
end
