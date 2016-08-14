class Web::Users::TasksController < Web::ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @tasks = Task.includes(:user)
      .where(user_id: params[:user_id].to_i)
      .most_recent_first
  end
end
