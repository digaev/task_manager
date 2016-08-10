module UserSession
  def create_user_session!(user)
    session[:user_token] = user.token
  end

  def destroy_user_session!
    session.delete(:user_token)
  end

  def authenticate_user!
    user_id_from_token
  rescue
    redirect_to new_session_path
  end

  def user_id_from_token
    token = session[:user_token]
    payload = Token.decode(token)
    payload['user_id']
  rescue
    raise Exceptions::InvalidAuthToken
  end
end
