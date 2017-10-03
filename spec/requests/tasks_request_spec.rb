# frozen_string_literal: true

require 'spec_helper'

describe TasksController, type: :request do
  let(:user) { create :user }
  before { sign_in user }

  describe 'access control' do
    before { sign_out user }

    it "denies access to 'create'" do
      post tasks_url
      expect(response).to redirect_to user_session_path
    end

    it "denies access to 'destroy'" do
      delete task_url(37)
      expect(response).to redirect_to user_session_path
    end
  end

#=begin
  # TODO: see about getting rid of this thing.
  def mock_task(stubs = {})
    (@mock_task ||= mock_model(Task).as_null_object).tap do |task|
      stubs.each_key do |k|
        allow(task).to receive(k)
      end
    end
  end
#=end

  describe 'GET index' do
  # describe 'GET /tasks' do
    it 'lists tasks' do
      sign_out user
      get tasks_url
      expect(response).to have_http_status(:redirect)
    end

    it 'assigns all tasks as @tasks' do
      # user = create :user
      # sign_in user
      get tasks_url
      expect(response).to have_http_status(:success)
    end
  end

  # describe '#index', type: :feature do
  describe '#index', type: :controller do
    # TODO: move this back to controller spec
    xit 'assigns all tasks as @tasks' do
      #allow(Task).to receive(:all) { [mock_task] }
      # user = create :user
      # sign_in user
      allow(user).to receive(:all) { [mock_task] }
      get :index
      expect(response).to have_http_status(:success)
      # expect(assigns(:tasks)).to eq([mock_task])
    end
  end

  describe 'GET show' do
    it 'assigns the requested task as @task' do
      allow(Task).to receive(:find).with('37') { mock_task }
      # user = create :user
      sign_in user
      get task_url(37)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET new' do
    it 'assigns a new task as @task' do
      # user = create :user
      # sign_in user
      get new_task_url
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested task as @task' do
      allow(Task).to receive(:find).with('37') { mock_task }
      # user = create :user
      # sign_in user
      get edit_task_url(37)
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    before(:each) do
      # user = create :user
      # sign_in user
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
          post tasks_url, params: parameters
        end.to change(Task, :count).by(1)
        expect(Task.last.tags).to eq(tags)
      end

      it 'assigns a newly created task as @task' do
        create :user, email: 'foo@bar.com'
        post tasks_url, params: { task: { 'description' => 'some description' } }
        expect(response).to have_http_status(:redirect)
      end

      it 'redirects to the created task' do
        post tasks_url, params: { task: { 'description' => 'some description' } }
        expect(response).to redirect_to(task_url(Task.last))
      end
    end

    context 'with invalid params' do
      it 'does not save the new contact' do
        expect do
          post tasks_url, params: { task: { foo: 'bar' } }
        end.to_not change(Task, :count)
      end

      it 're-renders the new template' do
        create :user, email: 'foo@bar.com'
        post tasks_url, params: { task: { foo: 'bar' } }
        expect(response).to have_http_status(:forbidden)
      end

      it 'assigns a newly built but unsaved task as @task' do
        allow_any_instance_of(Profile).to receive(:save).and_return(false)
        post tasks_url, params: { task: { 'invalid' => 'params' } }
      end
    end
  end

  describe '#update' do
    let!(:task) { create :task }
    let!(:user) { create :user, email: 'foobar@io.io' }

    before { sign_in user }

    context 'with valid params' do
      it 'updates the requested task' do
        put task_url(task.id), params: { task: { 'description' => 'description' } }
        task.reload
        expect(task.description).to eq 'description'
      end

      it 'starts task and sets time' do
        put task_url(task.id), params: { task: { 'started' => 'true' } }
        task.reload
        expect(response).to have_http_status(:redirect)
        expect(task.started).to be true
        expect(task.start_time.year).to eq 2017
      end

      it 'redirects to the task' do
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
      end

      it "re-renders the 'edit' template" do
        put task_url(task.id), params: { task: { 'description' => '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE destroy' do
    before(:each) do
      # @user = build :user
      # sign_in @user
    end

    it 'destroys the requested task' do
      expect(Task).to receive(:find).with('37') { mock_task }
      expect(mock_task).to receive(:destroy)
      delete task_url(37)
    end

    it 'redirects to the tasks list' do
      allow(Task).to receive(:find) { mock_task(id: '37') }
      delete task_url(37)
      expect(response).to redirect_to new_task_path
    end
  end
end
