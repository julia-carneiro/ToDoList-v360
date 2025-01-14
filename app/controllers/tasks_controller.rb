class TasksController < ApplicationController
  before_action :set_task, only: %i[ update destroy ]

  # Sets the list based on the provided list ID
  before_action :set_list

  # Ensures the current user is the owner of the list
  before_action :verify_owner

  # GET /tasks or /tasks.json
  def index
    # Fetches tasks associated with the current list, paginated (4 per page)
    @tasks = @list.tasks.page(params[:page]).per(4)

    # Initializes a new task object for the task creation form
    @task = Task.new

    respond_to do |format|
      format.html
      format.json { render json: @lists }
    end
  end

  # POST /tasks or /tasks.json
  def create
    # Builds a new task associated with the current list
    @task = @list.tasks.build(task_params)

    respond_to do |format|
      if @task.save
        # Redirects to the tasks index page for the current list upon successful creation
        format.html { redirect_to list_tasks_path(@list) }
        format.json { render :show, status: :created, location: @task }
      else
        # Renders the task creation form again with errors
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    if params[:completed].present?
      # Updates the `completed` status of the task
      @task.update(completed: params[:completed] == "true")

      respond_to do |format|
        # Renders the task partial dynamically for Turbo Streams
        format.turbo_stream { render turbo_stream: turbo_stream.replace("task_#{@task.id}", partial: "tasks/task", locals: { task: @task }) }
        format.html { redirect_to list_tasks_path(@list) }
      end
    else
      respond_to do |format|
        if @task.update(task_params)
          # Handles both Turbo Stream and regular HTML/JSON updates
          format.turbo_stream { render turbo_stream: turbo_stream.replace("task_#{@task.id}", partial: "tasks/task", locals: { task: @task }) }
          format.html { redirect_to [ @list, @task ] }
          format.json { render :show, status: :ok, location: @task }
        else
          # Renders the edit form again with errors
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @task.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      # Redirects to the tasks index page upon successful deletion
      format.html { redirect_to [ @list, @task ], status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      # Finds the task by ID
      @task = Task.find_by(id: params[:id])
    end

    def set_list
      # Finds the list by ID; redirects if not found
      @list = List.find_by(id: params[:list_id])
      redirect_to lists_path, alert: "You don't have access to this list" if @list.nil?
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.expect(task: [ :title, :completed, :list_id ])
    end

    def verify_owner
      # Ensures the current user is the owner of the list
      unless @list.user == current_user
        redirect_to lists_path, alert: "You don't have access to this list"
      end
    end
end
