module UserSession
  def create_user_session!(user)
    session[:user_token] = user.token
  end

  def destroy_user_session!
    session.delete(:user_token)
  end
end
