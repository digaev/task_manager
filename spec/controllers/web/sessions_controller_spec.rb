require 'rails_helper'

RSpec.describe Web::SessionsController, type: :controller do
  describe '#new' do
    it 'creates instance of Forms::Session' do
      expect(Forms::Session).to receive(:new)
      get :new
    end
  end

  describe '#create' do
    it 'creates session with permitted params' do
      user = create :user
      form = Forms::Session.new(
        email: user.email,
        password: user.password
      )
      params = {
        email: user.email,
        password: user.password
      }
      permitted_params = ActionController::Parameters.new(params).permit(
        :email, :password
      )
      expect(Forms::Session).to receive(:new).with(permitted_params).and_return(form)
      post :create, params: { session: params }
    end

    context 'when create succeeds' do
      before do
        @user = create :user
        allow(User).to receive(:create).and_return @user
      end

      it 'creates session and redirects to web/users/tasks#index' do
        expect(controller).to receive(:create_user_session!).with(@user)
        expect(User).to receive(:find_by_email).with(@user.email).and_return(@user)
        expect(@user).to receive(:authenticate).with(@user.password).and_return(@user)

        post :create, params: { session: { email: @user.email, password: @user.password } }
        expect(response).to redirect_to(user_tasks_path(@user))
        expect(controller).to set_flash[:notice]
      end
    end

    context 'when create failed' do
      before do
        @user = create :user
        @user.password = 'invalid'
        allow(User).to receive(:create).and_return @user
      end

      it 'renders #new' do
        post :create, params: { session: { email: @user.email, password: @user.password } }
        expect(response).to render_template(:new)
        expect(controller).to set_flash[:error]
      end
    end
  end

  describe '#destroy' do
    before do
      user = create :user
      params = {
        email: user.email,
        password: user.password
      }
      post :create, params: { session: params }
    end

    it 'destroys user session' do
      allow(controller).to receive(:destroy_user_session!)
      delete :destroy
      expect(response).to redirect_to(root_url)
    end
  end
end
