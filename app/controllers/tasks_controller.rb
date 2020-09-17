# frozen_string_literal: true

class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = current_user.tasks.all
    # @tasks = Task.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @tasks }
    end
  end

  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @task }
    end
  end

  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def permitted_params
    params.require(:task).permit(:description, :started, :tags, :label)
  end

  def create
    # Really ought to catch the errors here. Then again, doing
    # create without "!" allows for redirecting appropriately.
    # Keep an eye out for better ways to do this.
    # @task = current_user.tasks.create!(permitted_params)

    @task = current_user.tasks.create(permitted_params)

    # Create the time stamp if the task is started.
    # This will need to be done in the edit method
    # as well.  Will dry it out afterward.
    @task.start_time = Time.now if @task.started?

    respond_to do |format|
      if @task.valid?
        format.html { redirect_to(@task, flash: { success: 'Task was successfully created.' }) }
        format.xml  { render xml: @task, status: :created, location: @task }
      else
        format.html { render action: 'new', status: :forbidden }
        format.xml  { render xml: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      # if @task.update_attributes(params[:task])
      if @task.update(permitted_params)
        if @task.started?
          @task.start_time = Time.now
          @task.save
        end
        format.html { redirect_to(@task, notice: 'Task was successfully updated.') }
      else
        format.html { render action: 'edit', status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(new_task_path, flash: { success: 'Task was successfully deleted.' }) }
      format.xml  { head :ok }
    end
  end
end
