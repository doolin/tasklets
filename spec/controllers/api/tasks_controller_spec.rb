# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::TasksController do
  let(:user) { create :user }
  before { request.headers.merge! user.create_new_auth_token }

  describe '#index' do
  end

  # TODO: should not be necessary with API, but I'm leaving
  # it here to think about for a bit.
  describe '#new' do
  end

  describe '#create' do
    it 'a task for signed in user' do
      expect do
        post :create, params: { task: { description: 'some task' } }
        expect(response).to have_http_status(:created)
      end.to change { Task.count }.by 1
    end
  end

  describe '#show' do
    it 'shows' do
      task = Task.create! description: 'foobar', user: user
      get :show, params: { id: task.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#edit' do
  end

  describe '#update' do
  end

  describe '#destroy' do
  end
end
