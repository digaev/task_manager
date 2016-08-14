class Web::SessionsController < Web::ApplicationController
  def new
    @form = Forms::Session.new
  end

  def create
    @form = Forms::Session.new(params.require(:session).permit(:email, :password))
    if @form.valid?
      user = User.find_by_email(@form.email)
      if user && user.authenticate(@form.password)
        create_user_session!(user)
        flash[:notice] = 'You are successfully signed in.'
        redirect_to user_tasks_path(user) and return
      else
        flash[:error] = 'Invalid email or password.'
      end
    end
    render :new
  end

  def destroy
    flash[:notice] = 'You are successfully signed out.' if user_id_from_token
    destroy_user_session!
    redirect_to root_url
  end
end
