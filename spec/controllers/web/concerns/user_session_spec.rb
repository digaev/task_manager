RSpec.describe UserSession, type: :controller do
  controller(Web::ApplicationController) do
    include UserSession
  end

  describe '#create_user_session!' do
    it 'creates user session' do
      user = create :user
      controller.create_user_session!(user)
      expect(session[:user_token]).to eq(user.token)
    end
  end
end
