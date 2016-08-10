class Web::Users::TasksController < Web::ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:show, :edit, :update]

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

  private

  def set_task
    @task = Task.find_by_user_id_and_id!(user_id_from_token, params[:id].to_i)
  end
end
