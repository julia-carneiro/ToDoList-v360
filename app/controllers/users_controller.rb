class UsersController < ApplicationController
  allow_unauthenticated_access only: [ :new, :create ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/new
  def new
    # Initializes a new user instance for the signup form
    @user = User.new
  end

  # POST /users or /users.json
  def create
    # Creates a new user instance with the provided parameters
    @user = User.new(user_params)

    respond_to do |format|
      # Checks if the email address is already registered
      if User.exists?(email_address: @user.email_address)
        flash[:alert] = "E-mail already registered. Please, try another address."
        format.html { render :new, status: :unprocessable_entity }
      elsif @user.save
        # Sends a confirmation email asynchronously upon successful user creation
        UserMailer.welcome_and_confirmation_email(@user).deliver_later

        # Redirects to the login page with a notice to confirm the email address
        format.html { redirect_to new_session_path, notice: "Please check your email to confirm your account." }
        format.json { render :show, status: :created, location: @user }
      else
        # Handles password mismatch or other validation errors
        flash[:alert] = "Passwords did not match."
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
