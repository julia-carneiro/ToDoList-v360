class ListsController < ApplicationController
  before_action :set_list, only: %i[ update destroy ]
  # Verifies if current user is the owner of the list.
  before_action :verify_owner, only: %i[ update destroy ]

  # GET /lists or /lists.json
  # Action to fetch and display lists for the current user
  def index
    # Fetches the paginated lists of the current user
    @lists = current_user.lists.page(params[:page]).per(8)

    # This is used in the Create list form to render the modal
    @form_list = current_user.lists.new

    # Responds to both HTML and JSON formats
    respond_to do |format|
      format.html
      format.json { render json: @lists }
    end
  end

  # POST /lists or /lists.json
  # Action to create a new list for the current user
  def create
    # Instantiates a new list with the provided parameters
    @list = current_user.lists.new(list_params)

    respond_to do |format|
      if @list.save
        # Redirects to the list's page upon successful creation
        format.html { redirect_to @list }
        format.json { render :show, status: :created, location: @list }
      else
        # Renders the form again with error messages if creation fails
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1 or /lists/1.json
  # Action to update an existing list
  def update
    respond_to do |format|
      if @list.update(list_params)
        # Redirects to the updated list's page upon success
        format.html { redirect_to @list }
        format.json { render :show, status: :ok, location: @list }
      else
        # Renders the form again with error messages if the update fails
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1 or /lists/1.json
  # Action to delete an existing list
  def destroy
    @list.destroy!

    respond_to do |format|
      # Redirects to the lists index page upon successful deletion
      format.html { redirect_to lists_path, status: :see_other }
      format.json { head :no_content }
    end
  end

  private

    # Finds the list based on the `id` parameter
    def set_list
      @list = List.find_by(id: params[:id])

      # Redirects to the index page with an alert if the list is not found
      redirect_to lists_path, alert: "You don't have access to this list" if @list.nil?
    end

    # Only allow a list of trusted parameters through.
    def list_params
      params.expect(list: [ :name, :description ])
    end

    # Verifies if the current user owns the list
    def verify_owner
      unless @list.user == current_user
        # Redirects with an alert if the user is not the owner
        redirect_to lists_path, alert: "You don't have access to this list"
      end
    end
end
