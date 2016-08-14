class Web::TasksController < Web::ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_task, only: [:show, :edit, :update, :destroy, :change_state]

  def index
    @tasks = Task.includes(:user).order(created_at: :desc)
  end

  def create
    @task = Task.new(params.require(:task).permit(
      :name, :description, :state, :attachment
    ))
    @task.user_id = user_id_from_token
    if @task.save
      redirect_to user_tasks_path(@task.user)
    else
      render :new
    end
  end

  def update
    if @task.update_attributes(params.require(:task).permit(
      :name, :description, :state, :attachment
    ))
      redirect_to user_tasks_path(@task.user)
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to (request.referer || tasks_path)
  end

  def change_state
    @task.update_attributes(state: params[:state])
    respond_to do |format|
      format.html { redirect_to action: :index }
      format.js { render js: 'document.location.reload();' }
    end
  end

  private

  def set_task
    @task =
      if current_user.admin?
        Task.find(params[:id])
      else
        Task.find_by_id_and_user_id!(params[:id], current_user.id)
      end
  end
end
