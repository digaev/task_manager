class Web::Users::TasksController < Web::ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = Task.includes(:user)
      .where(user_id: user_id_from_token)
      .most_recent_first
  end
end
