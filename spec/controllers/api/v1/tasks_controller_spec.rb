# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    RSpec.describe TasksController do
      let(:user) { create :user }
      before { request.headers.merge! user.create_new_auth_token }

      describe '#create' do
        it 'a task for signed in user' do
          expect do
            post :create, params: { task: { description: 'some task', label: 'some label' } }
            expect(response).to have_http_status(:created)
          end.to change { Task.count }.by 1
        end
      end

      describe '#show' do
        it 'task found by task id' do
          task = create :task
          get :show, params: { id: task.id }
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
