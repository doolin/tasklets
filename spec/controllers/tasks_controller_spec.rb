require 'spec_helper'

describe TasksController do
  render_views

  describe 'access control' do
    it "should deny access to 'create'" do
      post :create
      expect(response).to redirect_to user_session_path
    end

    it "should deny access to 'destroy'" do
      delete :destroy, id: 1
      expect(response).to redirect_to user_session_path
    end
  end

  def mock_task(stubs={})
    (@mock_task ||= mock_model(Task).as_null_object).tap do |task|
      task.stub(stubs) unless stubs.empty?
      # allow(task).to receive(stubs) unless stubs.empty?
    end
  end

  describe 'GET index' do
    it 'assigns all tasks as @tasks' do
      Task.stub(:all) { [mock_task] }
      get :index
      expect(assigns(:tasks)).to eq([mock_task])
    end
  end

  describe 'GET show' do
    it 'assigns the requested task as @task' do
      Task.stub(:find).with('37') { mock_task }
      get :show, id: '37'
      expect(assigns(:task)).to be(mock_task)
    end
  end

  describe 'GET new' do
    it 'assigns a new task as @task' do
      Task.stub(:new) { mock_task }
      get :new
      expect(assigns(:task)).to be(@mock_task)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested task as @task' do
      Task.stub(:find).with('37') { mock_task }
      get :edit, id: '37'
      expect(assigns(:task)).to be(mock_task)
    end
  end

  describe 'POST create' do
    before(:each) do
      @user = FactoryGirl.build(:user)
      sign_in @user
      controller.stub(:authenticate_user!)
    end

    describe 'with valid params' do
      xit 'assigns a newly created task as @task' do
        Task.stub(:new).with({ 'these' => 'params' }) { mock_task(save: true) }
        post :create, task: { 'these' => 'params' }
        expect(assigns(:task)).to be(@mock_task)
      end

      xit 'redirects to the created task' do
        controller.stub(:authenticate_user!)
        Task.stub(:new) { mock_task(save: true) }
        post :create, task: {}
        expect(response).to redirect_to(task_url(mock_task))
      end
    end

    describe 'with invalid params' do
      #before(:each) do
      #  sign_out @user
      #end

      it 'does not save the new contact' do
        expect do
          post :create, task: {}
        end.to_not change(Task,:count)
      end

      it 're-renders the new method' do
        post :create, task: {}
        expect(response).to render_template :new
      end

      it 'assigns a newly created but unsaved task as @task' do
        Task.stub(:new).with({ 'these' => 'params' }) { mock_task(save: false) }
        post :create, task: { 'these' => 'params' }
        expect(assigns(:task)).to be(@mock_task)
      end

      it "re-renders the 'new' template" do
        Task.stub(:new) { mock_task(save: false) }
        post :create, task: {}
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      xit 'updates the requested task' do
        Task.should_receive(:find).with('37') { mock_task }
        mock_task.should_receive(:update_attributes).with({ 'these' => 'params' })
        put :update, id: '37', task: { 'these' => 'params' }
      end

      xit 'assigns the requested task as @task' do
        Task.stub(:find) { mock_task(update_attributes: true) }
        put :update, id: '1'
        assigns(:task).should be(mock_task)
      end

      xit 'redirects to the task' do
        Task.stub(:find) { mock_task(update_attributes: true) }
        put :update, id: 1
        response.should redirect_to(task_url(mock_task))
      end
    end

    describe 'with invalid params' do
      it 'assigns the task as @task' do
        Task.stub(:find) { mock_task(update_attributes: false) }
        put :update, id: '1'
        expect(assigns(:task)).to be(mock_task)
      end

      it "re-renders the 'edit' template" do
        Task.stub(:find) { mock_task(update_attributes: false) }
        put :update, id: '1'
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      @user = build :user
      sign_in @user
      allow(controller).to receive(:authenticate_user!)
    end

    it 'destroys the requested task' do
      Task.should_receive(:find).with('37') { mock_task }
      mock_task.should_receive(:destroy)
      delete :destroy, id: '37'
    end

    it 'redirects to the tasks list' do
      Task.stub(:find) { mock_task(id: '37') }
      delete :destroy, id: '37'
      expect(response).to redirect_to new_task_path
    end
  end
end
