class Web::UsersController < Web::ApplicationController
  def create
    @user = User.create(params.require(:user).permit(:email, :password))
    if @user.valid?
      create_user_session!(@user)
      redirect_to user_tasks_path(@user)
    else
      render :new
    end
  end

  def new
    @user = User.new
  end
end
