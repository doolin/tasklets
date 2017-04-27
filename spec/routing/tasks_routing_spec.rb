# frozen_string_literal: true

require 'spec_helper'

describe TasksController do
  describe 'routing' do
    it 'recognizes and generates #index' do
      expect(get: '/tasks').to route_to(controller: 'tasks', action: 'index')
    end

    it 'recognizes and generates #new' do
      expect(get: '/tasks/new').to route_to(controller: 'tasks', action: 'new')
    end

    it 'recognizes and generates #show' do
      expect(get: '/tasks/1').to route_to(controller: 'tasks', action: 'show', id: '1')
    end

    it 'recognizes and generates #edit' do
      expect(get: '/tasks/1/edit').to route_to(controller: 'tasks', action: 'edit', id: '1')
    end

    it 'recognizes and generates #create' do
      expect(post: '/tasks').to route_to(controller: 'tasks', action: 'create')
    end

    it 'recognizes and generates #update' do
      expect(put: '/tasks/1').to route_to(controller: 'tasks', action: 'update', id: '1')
    end

    it 'recognizes and generates #destroy' do
      expect(delete: '/tasks/1').to route_to(controller: 'tasks', action: 'destroy', id: '1')
    end
  end
end
