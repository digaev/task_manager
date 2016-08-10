require 'rails_helper'

RSpec.describe Web::Users::TasksController, type: :controller do
  describe '#index' do
    before do
      @user = create :user
      controller.create_user_session!(@user)
      allow(controller).to receive(:authenticate_user!)
    end

    it 'returns all tasks of user' do
      tasks = Task.includes(:user).where(user_id: @user.id)

      allow(Task).to receive(:includes).and_return(tasks)
      expect(tasks).to receive(:where).with(user_id: @user.id).and_return(tasks)

      get :index, params: { user_id: @user.id }
    end
  end

  describe '#create' do
    before do
      @user = create :user
      controller.create_user_session!(@user)
      allow(controller).to receive(:authenticate_user!)
    end

    it 'creates task with permitted params' do
      task = build :task, user: @user
      params = {
        name: task.name,
        description: task.description
      }
      permitted_params = ActionController::Parameters.new(params).permit(
        :name, :description
      )
      expect(Task).to receive(:new).with(permitted_params).and_return(task)
      post :create, params: { user_id: task.user_id, task: params }
    end

    context 'when create succeeds' do
      before do
        @task = build :task, user: @user
        allow(@task).to receive(:save)
      end

      it 'creates task and redirects to web/user/tasks#index' do
        post :create, params: { user_id: @task.user_id, task: {
          name: @task.name, description: @task.description
        } }
        expect(@user.tasks.count).to eq(1)
        expect(response).to redirect_to(user_tasks_path(@task.user))
      end
    end

    context 'when create fails' do
      it 'renders #new' do
        post :create, params: { user_id: @user.id, task: {
          name: '', description: ''
        } }
        expect(response.status).to eq(200)
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#edit' do
    before do
      @user = create :user
      @task = create :task, user: @user
      controller.create_user_session!(@user)
      allow(controller).to receive(:authenticate_user!)
    end

    it 'finds task from params and user from token' do
      expect(Task).to receive(:find_by_user_id_and_id!).with(@user.id, @task.id).and_return(@task)
      get :edit, params: { id: @task.id, user_id: @user.id }
    end
  end

  describe '#update' do
    before do
      @user = create :user
      @task = create :task, user: @user
      controller.create_user_session!(@user)
      allow(controller).to receive(:authenticate_user!)
    end

    it 'finds task from params and user from token' do
      expect(Task).to receive(:find_by_user_id_and_id!).with(@user.id, @task.id).and_return(@task)
      expect(@task).to receive(:update_attributes).and_return(true)

      patch :update, params: { id: @task.id, user_id: @user.id, task: { name: '1', description: '2' } }
    end

    context 'when task is found and updated' do
      it 'redirects to web/user/tasks#index' do
        patch :update, params: { id: @task.id, user_id: @user.id, task: { name: '1', description: '2' } }
        expect(response).to redirect_to(user_tasks_path(@user))
      end
    end

    context 'when task update failed' do
      it 'renders #edit' do
        patch :update, params: { id: @task.id, user_id: @user.id, task: { name: '', description: '' } }
        expect(response).to render_template(:edit)
      end
    end
  end
end
