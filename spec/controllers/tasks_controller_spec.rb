require 'spec_helper'

describe TasksController do

  render_views

  describe "access control" do

    it "should deny access to 'create'" do
      post :create
      #response.should redirect_to('users/sign_in')
      response.should redirect_to user_session_path
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to user_session_path
    end
  end

  def mock_task(stubs={})
    (@mock_task ||= mock_model(Task).as_null_object).tap do |task|
      task.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all tasks as @tasks" do
      Task.stub(:all) { [mock_task] }
      get :index
      assigns(:tasks).should eq([mock_task])
    end
  end

  describe "GET show" do
    it "assigns the requested task as @task" do
      Task.stub(:find).with("37") { mock_task }
      get :show, :id => "37"
      assigns(:task).should be(mock_task)
    end
  end

  describe "GET new" do
    it "assigns a new task as @task" do
      Task.stub(:new) { mock_task }
      get :new
      assigns(:task).should be(@mock_task)
    end
  end

  describe "GET edit" do
    it "assigns the requested task as @task" do
      Task.stub(:find).with("37") { mock_task }
      get :edit, :id => "37"
      assigns(:task).should be(mock_task)
    end
  end

  describe "POST create" do

    before(:each) do
      @user = FactoryGirl.build(:user)
      sign_in @user
      controller.stub(:authenticate_user!)
    end

    describe "with valid params" do
      it "assigns a newly created task as @task" do
        Task.stub(:new).with({'these' => 'params'}) { mock_task(:save => true) }
        post :create, :task => {'these' => 'params'}
        assigns(:task).should be(@mock_task)
      end

      it "redirects to the created task" do
        controller.stub(:authenticate_user!)
        Task.stub(:new) { mock_task(:save => true) }
        post :create, :task => {}
        response.should redirect_to(task_url(mock_task))
      end
    end

    describe "with invalid params" do

      #before(:each) do
      #  sign_out @user
      #end

      it "does not save the new contact" do
        expect{
          post :create, task: {}
        }.to_not change(Task,:count)
      end

      it "re-renders the new method" do
        post :create, task: {}
        response.should render_template :new
      end

      it "assigns a newly created but unsaved task as @task" do
        Task.stub(:new).with({'these' => 'params'}) { mock_task(:save => false) }
        post :create, :task => {'these' => 'params'}
        assigns(:task).should be(@mock_task)
      end

      it "re-renders the 'new' template" do
        Task.stub(:new) { mock_task(:save => false) }
        post :create, :task => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested task" do
        Task.should_receive(:find).with("37") { mock_task }
        mock_task.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :task => {'these' => 'params'}
      end

      it "assigns the requested task as @task" do
        Task.stub(:find) { mock_task(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:task).should be(mock_task)
      end

      it "redirects to the task" do
        Task.stub(:find) { mock_task(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(task_url(mock_task))
      end
    end

    describe "with invalid params" do
      it "assigns the task as @task" do
        Task.stub(:find) { mock_task(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:task).should be(mock_task)
      end

      it "re-renders the 'edit' template" do
        Task.stub(:find) { mock_task(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do

    before(:each) do
      @user = FactoryGirl.build(:user)
      sign_in @user
      controller.stub(:authenticate_user!)
    end

    it "destroys the requested task" do
      Task.should_receive(:find).with("37") { mock_task }
      mock_task.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    # app works correctly, test doesn't work, probably should delete it.
    # certainly need to fix it or write a different test.
    it "redirects to the tasks list" do
      Task.stub(:find) { mock_task(:id => "37") }
      delete :destroy, :id => "37"
      response.should redirect_to new_task_path
    end

  end

end
