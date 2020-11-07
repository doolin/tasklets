# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProfilesController do
  let!(:user) { create :user }
  before { request.headers.merge! user.create_new_auth_token }

  # describe '#index' do
  # end

  describe '#create' do
    example 'profile for signed in user' do
      expect do
        post :create, params: { profile: { firstname: 'fooish' } }
        expect(response).to have_http_status(:created)
      end.to change { Profile.count }.by 1
    end
  end

  describe '#show' do
    example 'profile found by profile id' do
      profile = Profile.create! firstname: 'foobar', user: user
      get :show, params: { id: profile.id }
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
