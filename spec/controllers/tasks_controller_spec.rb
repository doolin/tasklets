# frozen_string_literal: true

require 'spec_helper'

describe TasksController, type: :controller do
  let(:user) { create :user }
  before { sign_in user }

  render_views

  describe 'access control' do
    before { sign_out user }

    it "denies access to 'create'" do
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

  describe '#index' do
    it 'lists tasks for signed in user' do
      allow(user).to receive(:all) { [mock_task] }
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe '#show' do
    it 'finds the task' do
      allow(Task).to receive(:find).with('37') { mock_task }
      get :show, params: { id: '37' }
      expect(response).to have_http_status(:ok)
    end

    it 'does not find the task' do
      get :show, params: { id: '37' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe '#new' do
    it '' do
      get :new
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#edit' do
    it 'successfully edits the correct task' do
      allow(Task).to receive(:find).with('37') { mock_task }
      get :edit, params: { id: '37' }
      expect(response).to have_http_status(:ok)
    end
  end

  describe '#create' do
    context 'with valid params' do
      it 'creates a new task with correct parameters' do
        tags = %w[foo bar baz].join(',')
        parameters = {
          task: {
            description: 'some description',
            tags: tags,
            label: 'some label'
          }
        }

        expect do
          post :create, params: parameters
        end.to change(Task, :count).by(1)
        expect(Task.last.tags).to eq(tags)
      end

      it 'redirects to the created task' do
        create :user, email: 'foo@bar.com'
        post :create, params: { task: { description: 'some description', label: 'some label' } }

        aggregate_failures do
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to(task_url(Task.last))
        end
      end
    end

    context 'with invalid params' do
      it 'does not save the new contact' do
        expect do
          post :create, params: { task: { foo: 'bar' } }
        end.to_not change(Task, :count)
      end

      it 'will not allow assignment of wrong attributes' do
        post :create, params: { task: { foo: 'bar' } }
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe '#update' do
    let!(:task) { create :task, user: user }

    context 'with valid params' do
      it 'updates the requested task' do
        put :update, params: { id: task.id, task: { description: 'description' } }
        task.reload
        expect(task.description).to eq 'description'
      end

      it 'starts task and sets time' do
        put :update, params: { id: task.id, task: { started: 'true' } }
        task.reload
        expect(response).to have_http_status(:redirect)
        expect(task.started).to be true
        expect(task.start_time.year).to eq Time.now.year
      end

      it 'redirects to the task' do
        put :update, params: { id: task.id, task: { description: 'description' } }
        expect(response).to redirect_to(task_url(task))
      end
    end

    context 'with invalid params' do
      it 'will not update with invalid parameters' do
        expect do
          put :update, params: { id: task.id, task: { start_time: 'foobar' } }
          expect(response).to have_http_status(:redirect)
          task.reload
        end.to_not(change { task.description })
      end

      it 'does not process bad parameters' do
        allow(Task).to receive(:find) { mock_task(update: false) }
        put :update, params: { id: task.id, task: { description: 'description' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '#destroy' do
    it 'destroys the requested task' do
      expect(Task).to receive(:find).with('37') { mock_task }
      expect(mock_task).to receive(:destroy)
      delete :destroy, params: { id: '37' }
    end

    it 'redirects to the tasks list' do
      allow(Task).to receive(:find) { mock_task(id: '37') }
      delete :destroy, params: { id: '37' }
      expect(response).to redirect_to new_task_path
    end
  end
end
