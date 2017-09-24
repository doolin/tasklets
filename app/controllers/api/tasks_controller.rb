# frozen_string_literal: true

module Api
  class TasksController < BaseController
    def show
      render json: Task.first
    end
  end
end
