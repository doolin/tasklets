# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::TasksController do
  let(:user) { create :user}
  before { request.headers.merge! user.create_new_auth_token }

  describe '#show' do
    it 'shows' do
      # user = create :user
      # request.headers.merge! user.create_new_auth_token

      task = Task.create! description: 'foobar', user: user
      get :show, params: { id: task.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    it 'a task for signed in user' do
      expect {
        post :create, params: { task: { description: 'some task' } }
        expect(response).to have_http_status(:created)
      }.to change{Task.count}.by 1
    end
  end
end
