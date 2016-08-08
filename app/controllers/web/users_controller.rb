class Web::UsersController < Web::ApplicationController
  def create
    @user = User.create(params.require(:user).permit(:email, :password))
    if @user.valid?
      redirect_to root_url
    else
      render :new
    end
  end

  def new
    @user = User.new
  end
end
