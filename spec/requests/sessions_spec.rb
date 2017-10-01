require 'rails_helper'

# https://github.com/plataformatec/devise/wiki/How-To:-sign-in-and-out-a-user-in-Request-type-specs-(specs-tagged-with-type:-:request)

RSpec.describe "Sessions", type: :request do
  it "signs user in and out" do
    user = User.create!(email: "user@example.org", password: "very-secret", password_confirmation: "very-secret")
    user.save!

    sign_in user
    get authenticated_root_path

    expect(controller.current_user).to eq(user)

    sign_out user
    get authenticated_root_path
    expect {
      controller.current_user
    }.to raise_error(NoMethodError)
  end
end
