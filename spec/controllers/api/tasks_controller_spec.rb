# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController do
  describe '#show' do
    it 'shows' do
      task = Task.create! description: 'foobar'
      get :show, params: { id: task.id }
      expect(response).to have_http_status(:ok)
    end
  end
end
