module UserSession
  def create_user_session!(user)
    session[:user_token] = user.token
  end
end
