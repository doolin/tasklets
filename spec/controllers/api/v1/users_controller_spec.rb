# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    RSpec.describe UsersController do
      let(:user) { create :user }
      before { request.headers.merge! user.create_new_auth_token }

      # describe '#index' do
      # end

      describe '#create' do
        it 'a user for signed in user' do
          parameters = {
            user: {
              email: 'foo@bar.com',
              password: 'foobarski',
              password_confirmation: 'foobarski'
            }
          }
          expect do
            post :create, params: parameters
            expect(response).to have_http_status(:created)
          end.to change { User.count }.by 1
        end
      end

      describe '#show' do
        it 'user found by user id' do
          get :show, params: { id: user.id }
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
