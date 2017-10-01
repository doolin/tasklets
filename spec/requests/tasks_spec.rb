# frozen_string_literal: true

require 'spec_helper'

describe 'Tasks', type: :request do
  describe 'GET /tasks' do
    it 'lists tasks' do
      get tasks_url
      # expect(response.status).to be(200)
      expect(response).to have_http_status(:redirect)
    end
  end
end
