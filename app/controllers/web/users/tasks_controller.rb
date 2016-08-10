class Web::Users::TasksController < Web::ApplicationController
  before_action :authenticate_user!

  def index
    @tasks = Task.includes(:user)
      .where(user_id: user_id_from_token)
      .most_recent_first
  end

  def create
    @task = Task.new(params.require(:task).permit(
      :name, :description
    ))
    @task.user_id = user_id_from_token
    if @task.save
      redirect_to user_tasks_path(@task.user)
    else
      render :new
    end
  end
end
