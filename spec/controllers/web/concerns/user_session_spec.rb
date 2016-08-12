RSpec.describe UserSession, type: :controller do
  controller(Web::ApplicationController) do
    include UserSession
  end

  describe '#create_user_session! and #destroy_user_session!' do
    it 'creates and destroys user session' do
      user = create :user
      controller.create_user_session!(user)
      expect(session[:user_token]).to eq(user.token)

      controller.destroy_user_session!
      expect(session[:user_token]).to be(nil)
    end
  end

  describe '#user_id_from_token' do
    it 'returns user_id from token' do
      user = create :user
      controller.create_user_session!(user)
      expect(controller.user_id_from_token).to eq(user.id)
    end

    it 'should raise Exceptions::InvalidAuthToken' do
      expect{controller.user_id_from_token}.to raise_error(Exceptions::InvalidAuthToken)
    end
  end

  describe '#authenticate_user!' do
    it 'authenticates user' do
      user = create :user
      controller.create_user_session!(user)
      expect(controller.authenticate_user!).to eq(user.id)
    end
  end

  describe '#current_user' do
    it 'returns currently logged user' do
      user = create :user
      controller.create_user_session!(user)
      expect(controller.current_user).to eq(user)
    end
  end
end
