class Api::TasksController < BaseController
  def show
    render json: Task.first
  end
end
