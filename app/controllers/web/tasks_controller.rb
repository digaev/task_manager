class Web::TasksController < Web::ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.includes(:user).order(created_at: :desc)
  end

  def create
    @task = Task.new(task_params)
    @task.user_id = user_id_from_token
    if @task.save
      redirect_to user_tasks_path(@task.user)
    else
      render :new
    end
  end

  def update
    success = @task.update_attributes(task_params)
    respond_to do |format|
      format.js do
        if success
          render js: 'document.location.reload();'
        else
          render js: "alert(\"Whoops!\\n\\n#{ @task.errors.full_messages.join('\n') }\");"
        end
      end
      format.html do
        if success
          redirect_to user_tasks_path(@task.user)
        else
          render :edit
        end
      end
    end
  end

  def destroy
    @task.destroy
    redirect_to (request.referer || tasks_path)
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

  def task_params
    params.require(:task).permit(
      :name, :description, :state, :attachment
    )
  end
end
