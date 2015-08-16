class TasksController < ApplicationController

  before_filter :authenticate_user!, :only => [:new, :create, :destroy]

  # GET /tasks
  # GET /tasks.xml
  def index
    @tasks = Task.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])

    # Create the time stamp if the task is started.
    # This will need to be done in the edit method
    # as well.  Will dry it out afterward.
    if @task.started?
      @task.start_time = Time::now
    end

    respond_to do |format|
      if @task.save
        format.html { redirect_to(@task, :flash => { :success => 'Task was successfully created.' }) }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
    if @task.started?
      @task.start_time = Time::now
      @task.save
    end
        format.html { redirect_to(@task, :notice => 'Task was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => 'edit' }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(new_task_path, :flash => { :success => 'Task was successfully deleted.' }) }
      format.xml  { head :ok }
    end
  end
end
