# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    RSpec.describe 'api_v1_users request', type: :request do
      # The bang here forces evaluation right away, rather than
      # punting it to within the expectation block, which throw
      # off the count.
      let!(:user) { create :user }
      let(:headers) { user.create_new_auth_token }

      # describe '#index' do
      # end

      describe 'api_v1_users_url' do
        it 'creates new user with signed in user' do
          parameters = {
            user: {
              email: 'foo@bar.com',
              password: 'foobarski',
              password_confirmation: 'foobarski'
            }
          }
          expect do
            post api_v1_users_url, params: parameters, headers: headers
            expect(response).to have_http_status(:created)
          end.to change { User.count }.by 1
        end
      end

      describe 'api_v1_user_url(user)' do
        it 'shows user found by user id' do
          get api_v1_user_url(user), headers: headers
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
  end
end
