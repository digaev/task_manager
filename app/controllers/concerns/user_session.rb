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

  def current_user
    user_id = user_id_from_token
    @current_user = if @current_user && @current_user.id == user_id
                      @current_user
                    else
                      User.find_by_id(user_id)
                    end
  rescue
    nil
  end

  def user_id_from_token
    token = session[:user_token]
    payload = Token.decode(token)
    payload['user_id'].to_i
  rescue
    raise Exceptions::InvalidAuthToken
  end
end
