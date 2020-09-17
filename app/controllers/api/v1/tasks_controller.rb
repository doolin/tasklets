# frozen_string_literal: true

module Api
  module V1
    class TasksController < BaseController
      def show
        render json: Task.first.to_json
      end

      def create
        current_user.tasks.build(permitted_params).save!
        render json: {}, status: :created
      end

      def permitted_params
        params.require(:task).permit(:description, :label)
      end
    end
  end
end
