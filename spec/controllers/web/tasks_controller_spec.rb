require 'rails_helper'

RSpec.describe Web::TasksController, type: :controller do
  describe '#index' do
    it 'lists all tasks' do
      user = create :user
      create_list :task, 5, user: user

      allow(Task).to receive(:includes).with(:user)
      expect(Task.count).to eq(5)
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
      post :create, params: { task: params }
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
        post :create, params: { task: {
          name: '', description: ''
        } }
        expect(response.status).to eq(200)
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#edit' do
    context 'when user is not admin' do
      before do
        @user = create :user

        controller.create_user_session!(@user)
        expect(controller).to receive(:authenticate_user!).and_return(@user)
      end

      it 'can edit own tasks' do
        task = create :task, user: @user
        get :edit, params: { id: task.id }
        expect(response.status).to eq(200)
        expect(response).to render_template(:edit)
      end

      it 'can not edit tasks which not belongs to him' do
        task = create :task
        expect(@user.id != task.user_id).to be(true)

        get :edit, params: { id: task.id }
        expect(response.status).to eq(404)
      end
    end

    context 'when user is admin' do
      before do
        @admin = create :user, admin: true

        controller.create_user_session!(@admin)
        expect(controller).to receive(:authenticate_user!).and_return(@admin)
      end

      it 'can edit any tasks' do
        task = create :task
        expect(@admin.id != task.user_id).to be(true)

        get :edit, params: { id: task.id }
        expect(response.status).to eq(200)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe '#update' do
    context 'when user is not admin' do
      before do
        @user = create :user

        controller.create_user_session!(@user)
        expect(controller).to receive(:authenticate_user!).and_return(@user)
      end

      it 'can update own tasks' do
        task = create :task, user: @user
        patch :update, params: { id: task.id, task: { name: '1', description: '2' } }
        expect(response).to redirect_to(user_tasks_path(@user))
      end

      it 'can not update tasks which not belongs to him' do
        task = create :task
        expect(@user.id != task.user_id).to be(true)

        patch :update, params: { id: task.id, task: { name: '1', description: '2' } }
        expect(response.status).to eq(404)
      end
    end

    context 'when user is admin' do
      before do
        @admin = create :user, admin: true

        controller.create_user_session!(@admin)
        expect(controller).to receive(:authenticate_user!).and_return(@admin)
      end

      it 'can update any tasks' do
        task = create :task
        expect(@admin.id != task.user_id).to be(true)

        patch :update, params: { id: task.id, task: { name: '1', description: '2' } }
        expect(response).to redirect_to(user_tasks_path(task.user))
      end
    end
  end

  describe '#show' do
    context 'when user is not admin' do
      before do
        @user = create :user

        controller.create_user_session!(@user)
        expect(controller).to receive(:authenticate_user!).and_return(@user)
      end

      it 'can view own tasks' do
        task = create :task, user: @user
        get :show, params: { id: task.id }
        expect(response.status).to eq(200)
        expect(response).to render_template(:show)
      end

      it 'can not view tasks which not owned by user' do
        task = create :task
        expect(@user.id != task.user_id).to be(true)

        get :show, params: { id: task.id }
        expect(response.status).to eq(404)
      end
    end

    context 'when user is admin' do
      before do
        @admin = create :user, admin: true

        controller.create_user_session!(@admin)
        expect(controller).to receive(:authenticate_user!).and_return(@admin)
      end

      it 'can view any tasks' do
        task = create :task
        expect(@admin.id != task.user_id).to be(true)

        get :show, params: { id: task.id }
        expect(response.status).to eq(200)
        expect(response).to render_template(:show)
      end
    end
  end

  describe '#destroy' do
    before do
      @task = create :task
      controller.create_user_session!(@task.user)
      expect(controller).to receive(:authenticate_user!)
    end

    it 'destroys task' do
      expect {
        delete :destroy, params: { id: @task.id }
      }.to change(Task, :count).by(-1)
    end
  end
end
