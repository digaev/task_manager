require 'rails_helper'

RSpec.describe Web::UsersController, type: :controller do
  describe '#create' do
    it 'creates user with permitted params' do
      user = create :user
      params = {
        email: user.email,
        password: user.password
      }
      permitted_params = ActionController::Parameters.new(params).permit(
        :email, :password
      )
      expect(User).to receive(:create).with(permitted_params).and_return(user)
      post :create, params: { user: params }
    end

    context 'when create succeeds' do
      before do
        @user = create :user
        allow(User).to receive(:create).and_return @user
      end

      it 'creates session and redirects to web/users/tasks#index' do
        expect(controller).to receive(:create_user_session!).with(@user)

        post :create, params: { user: { email: @user.email, password: @user.password } }
        expect(response).to redirect_to(user_tasks_path(@user))
      end
    end

    context 'when create failed' do
      before do
        @user = build :user, password: ''
        allow(User).to receive(:create).and_return @user
      end

      it 'renders #new' do
        post :create, params: { user: { email: @user.email, password: @user.password } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#new' do
    it 'creates instance of User' do
      expect(User).to receive(:new)
      get :new
    end
  end
end
