class UsersController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if User.exists?(email_address: @user.email_address)
        flash[:alert] = "E-mail already registered. Please, try another adress."
        format.html { render :new, status: :unprocessable_entity }
      elsif @user.save
        UserMailer.welcome_and_confirmation_email(@user).deliver_now
        format.html { redirect_to new_session_path, notice: "Please check your email to confirm your account." }
        format.json { render :show, status: :created, location: @user }
      else
        flash[:alert] = @user.errors.full_messages.to_sentence
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:email_address, :password, :password_confirmation, :username)
    end
end
