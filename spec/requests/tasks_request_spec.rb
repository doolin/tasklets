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

  describe 'get tasks_url' do
    it 'redirects user to sign in' do
      sign_out user
      get tasks_url
      expect(response).to have_http_status(:redirect)
    end

    it 'lists tasks for user' do
      get tasks_url
      expect(response).to have_http_status(:success)
    end
  end

  describe 'get task_url/:id' do
    it 'assigns the requested task as @task' do
      task = create :task, user: user
      get task_url(task.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get new_task_url' do
    it 'assigns a new task as @task' do
      get new_task_url
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'get edit_task_url/:id' do
    it 'assigns the requested task as @task' do
      task = create :task, user: user
      get edit_task_url(task.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'post tasks_url' do
    context 'with valid params' do
      it 'creates a new task with correct parameters' do
        create :user, email: 'foo@bar.com'
        tags = %w[foo bar baz].join(',')
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

  describe 'put task_url/:id' do
    let!(:task) { create :task, user: user }

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
      it 'produces no change in attributes' do
        expect do
          put task_url(task.id), params: { task: { 'start_time' => 'foobar' } }
          task.reload
        end.to_not(change { task.description })
      end

      it "re-renders the 'edit' template" do
        put task_url(task.id), params: { task: { 'description' => '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'delete task_url/:id' do
    it 'destroys the requested task' do
      task = create :task, user: user
      expect do
        delete task_url(task.id)
        expect(response).to redirect_to new_task_path
      end.to change { Task.count }.by(-1)
    end
  end
end
