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
end
