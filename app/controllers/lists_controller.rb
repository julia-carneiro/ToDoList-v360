class ListsController < ApplicationController
  before_action :set_list, only: %i[ update destroy ]

  # GET /lists or /lists.json
  def index
    @lists = current_user.lists.page(params[:page]).per(8)
  end

  # GET /lists/new
  def new
    @list = current_user.lists.new
  end

  # POST /lists or /lists.json
  def create
    @list = current_user.lists.new(list_params)
    respond_to do |format|
      if @list.save
        format.html { redirect_to @list }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1 or /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to @list }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1 or /lists/1.json
  def destroy
    @list.destroy!

    respond_to do |format|
      format.html { redirect_to lists_path, status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = current_user.lists.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def list_params
      params.expect(list: [ :name, :description ])
    end
end
