# frozen_string_literal: true

require 'spec_helper'

describe TasksController do
  render_views

  describe 'access control' do
    it "denies access to 'create'" do
      user = create :user
      request.headers.merge!(user.create_new_auth_token)
      post :create
      expect(response).to redirect_to user_session_path
    end

    it "denies access to 'destroy'" do
      delete :destroy, params: { id: 1 }
      expect(response).to redirect_to user_session_path
    end
  end

  def mock_task(stubs = {})
    (@mock_task ||= mock_model(Task).as_null_object).tap do |task|
      stubs.each_key do |k|
        allow(task).to receive(k)
      end
    end
  end

  # First plan is porting everything to request specs.
  describe 'GET index', type: :request do
    it 'assigns all tasks as @tasks' do
      # allow(Task).to receive(:all) { [mock_task] }
      user = create :user
      sign_in user
      get tasks_url
      expect(response).to have_http_status(:success)
      # expect(assigns(:tasks)).to eq([mock_task])
    end
  end

  # describe '#index', type: :feature do
  describe '#index', type: :controller do
    it 'assigns all tasks as @tasks' do
      #allow(Task).to receive(:all) { [mock_task] }
      user = create :user
      sign_in user
      allow(user).to receive(:all) { [mock_task] }
      get :index
      expect(response).to have_http_status(:success)
      # expect(assigns(:tasks)).to eq([mock_task])
    end
  end

  describe 'GET show', type: :request do
    it 'assigns the requested task as @task' do
      allow(Task).to receive(:find).with('37') { mock_task }
      # get :show, params: { id: '37' }
      # expect(assigns(:task)).to be(mock_task)
      user = create :user
      sign_in user
      get task_url(37)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET new', type: :request do
    it 'assigns a new task as @task' do
      user = create :user
      sign_in user
      # get :new
      # expect(response).to have_http_status(:ok)
      get new_task_url
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET edit', type: :request do
    it 'assigns the requested task as @task' do
      allow(Task).to receive(:find).with('37') { mock_task }
      # get :edit, params: { id: '37' }
      user = create :user
      sign_in user
      get edit_task_url(37)
      expect(response).to have_http_status(:ok)
      # expect(assigns(:task)).to be(mock_task)
    end
  end

  describe '#create', type: :request do
    before(:each) do
      user = create :user
      sign_in user
      allow(controller).to receive(:authenticate_user!)
    end

    context 'with valid params' do
      it 'creates a new task with correct parameters' do
        create :user, email: 'foo@bar.com'
        tags = %w(foo bar baz).join(',')
        parameters = {
         task: {
           'description' => 'some description',
           'tags' => tags
         }
        }
        expect do
          # post :create, params: parameters
          # post :create, params: { task: { 'description' => 'some description' } }
          post tasks_url, params: parameters
        end.to change(Task, :count).by(1)
        expect(Task.last.tags).to eq(tags)
      end

      it 'assigns a newly created task as @task' do
        create :user, email: 'foo@bar.com'
        # post :create, params: { task: { 'description' => 'some description' } }
        post tasks_url, params: { task: { 'description' => 'some description' } }
        expect(response).to have_http_status(:redirect)
        # expect(assigns(:task)).to be_a(Task)
        # expect(assigns(:task)).to be_persisted
      end

      it 'redirects to the created task' do
        # post :create, params: { task: { 'description' => 'some description' } }
        post tasks_url, params: { task: { 'description' => 'some description' } }
        expect(response).to redirect_to(task_url(Task.last))
      end
    end

    context 'with invalid params' do
      it 'does not save the new contact' do
        expect do
          # post :create, params: { task: { foo: 'bar' } }
          post tasks_url, params: { task: { foo: 'bar' } }
        end.to_not change(Task, :count)
      end

      it 're-renders the new template' do
        create :user, email: 'foo@bar.com'
        # post :create, params: { task: { foo: 'bar' } }
        post tasks_url, params: { task: { foo: 'bar' } }
        # expect(response).to render_template :new
        expect(response).to have_http_status(:forbidden)
      end

      it 'assigns a newly built but unsaved task as @task' do
        allow_any_instance_of(Profile).to receive(:save).and_return(false)
        # post :create, params: { task: { 'invalid' => 'params' } }
        post tasks_url, params: { task: { 'invalid' => 'params' } }
        # expect(assigns(:task)).to be_a_new(Task)
      end
    end
  end

  describe '#update', type: :request do
    let!(:task) { create :task }
    let!(:user) { create :user, email: 'foobar@io.io' }

    before { sign_in user }

    context 'with valid params' do
      it 'updates the requested task' do
        # put :update, params: { id: task.id, task: { 'description' => 'description' } }
        put task_url(task.id), params: { task: { 'description' => 'description' } }
        task.reload
        expect(task.description).to eq 'description'
      end

      xit 'assigns the requested task as @task' do
        # put :update, params: { id: task.id, task: { 'description' => 'description' } }
        put task_url(task.id), params: { task: { 'description' => 'description' } }
        task.reload
        # expect(assigns(:task)).to eq(task)
      end

      it 'starts task and sets time' do
        # put :update, params: { id: task.id, task: { 'started' => 'true' } }
        put task_url(task.id), params: { task: { 'started' => 'true' } }
        task.reload
        expect(response).to have_http_status(:redirect)
        expect(task.started).to be true
        expect(task.start_time.year).to eq 2017
      end

      it 'redirects to the task' do
        # put :update, params: { id: task.id, task: { 'description' => 'description' } }
        put task_url(task.id), params: { task: { 'description' => 'description' } }
        expect(response).to redirect_to(task_url(task))
      end
    end

    context 'with invalid params' do
      # TODO: this feels weak.
      it 'assigns the task as @task' do
        # allow_any_instance_of(task).to receive(:update_attributes).and_return(:false)
        # put :update, params: { id: task.id, task: { 'description' => 'description' } }
        expect {
          put task_url(task.id), params: { task: { 'start_time' => 'foobar' } }
          task.reload
        }.to_not change{task.description}

        # expect(assigns(:task)).to be(mock_task)
      end

      it "re-renders the 'edit' template" do
        # allow(Task).to receive(:find) { mock_task(update_attributes: false) }
        # put :update, params: { id: task.id, task: { 'description' => 'description' } }
        # expect(response).to render_template('edit')

        put task_url(task.id), params: { task: { 'description' => '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE destroy', type: :request do
    before(:each) do
      @user = build :user
      sign_in @user
      allow(controller).to receive(:authenticate_user!)
    end

    it 'destroys the requested task' do
      expect(Task).to receive(:find).with('37') { mock_task }
      expect(mock_task).to receive(:destroy)
      # delete :destroy, params: { id: '37' }
      delete task_url(37) # params: { id: '37' }.to_json
    end

    it 'redirects to the tasks list' do
      allow(Task).to receive(:find) { mock_task(id: '37') }
      # delete :destroy, params: { id: '37' }
      delete task_url(37) # , params: { id: '37' }
      expect(response).to redirect_to new_task_path
    end
  end
end
