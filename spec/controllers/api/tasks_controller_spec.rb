# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::TasksController do
  describe '#show' do
    it 'shows' do
      user = create :user
      request.headers.merge! user.create_new_auth_token

      task = Task.create! description: 'foobar', user: user
      get :show, params: { id: task.id }
      expect(response).to have_http_status(:ok)
    end
  end
end
