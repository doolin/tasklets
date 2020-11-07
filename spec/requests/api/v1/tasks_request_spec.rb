# frozen_string_literal: true

require 'rails_helper'

module Api
  module V1
    RSpec.describe 'Task request', type: :request do
      let!(:user) { create :user }
      let(:header_params) { user.create_new_auth_token }

      # describe '#index' do
      # end

      # TODO: should not be necessary with API, but I'm leaving
      # it here to think about for a bit.
      # describe '#new' do
      # end

      describe 'api_v1_tasks_url' do
        it 'creates a task for signed in user' do
          parameters = { task: { description: 'some task', label: 'some label' } }

          expect do
            post api_v1_tasks_url, params: parameters, headers: header_params
            expect(response).to have_http_status(:created)
          end.to change { Task.count }.by 1
        end
      end

      describe 'api_v1_task_url/:id' do
        it 'returns task specified by :id' do
          task = create :task
          get api_v1_task_url(task), headers: header_params
          expect(response).to have_http_status(:ok)
        end
      end

      # TODO: edit should not be something we care about with API.
      # As above with new, I'm leaving it in here to think about
      # it for a bit.
      # describe '#edit' do
      # end

      # describe '#update' do
      # end

      # describe '#destroy' do
      # end
    end
  end
end
