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
        redirect_to user_tasks_path(user) and return
      end
    end
    render :new
  end
end
