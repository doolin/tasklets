# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'api_v1_profile request', type: :request do
  let!(:user) { create :user }
  let!(:header) { user.create_new_auth_token }

  # describe '#index' do
  # end

  describe 'api_v1_profiles_url' do
    example 'profile for signed in user' do
      parameters = {
        profile: {
          firstname: 'fooish'
        }
      }
      expect do
        post api_v1_profiles_url, params: parameters, headers: header
        expect(response).to have_http_status(:created)
      end.to change { Profile.count }.by 1
    end
  end

  describe 'api_v1_profile_url(profile)' do
    example 'profile found by profile id' do
      profile = Profile.create! firstname: 'foobar', user: user
      get api_v1_profile_url(profile), headers: header
      expect(response).to have_http_status(:ok)
    end
  end

  # describe '#edit' do
  # end

  # describe '#update' do
  # end

  # describe '#destroy' do
  # end
end
