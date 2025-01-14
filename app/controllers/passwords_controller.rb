class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ edit update ]

  def new
    # Renders the `new` view
  end

  # Handles the password reset request
  def create
    # Finds the user by email address
    if user = User.find_by(email_address: params[:email_address])
      # Sends a password reset email asynchronously
      PasswordsMailer.reset(user).deliver_later
    end

    # Redirects to the login page with a notice
    redirect_to new_session_path, notice: "Password reset instructions sent (if user with that email address exists)."
  end

  # Displays the password reset form
  def edit
    # Relies on `set_user_by_token` to set `@user` or handle invalid token cases
  end

  # Handles the password update process
  def update
    # Updates the user's password and password confirmation
    if @user.update(params.permit(:password, :password_confirmation))
      # Redirects to the login page upon success
      redirect_to new_session_path, notice: "Password has been reset."
    else
      # Redirects back to the reset form with an alert on failure
      redirect_to edit_password_path(params[:token]), alert: "Passwords did not match."
    end
  end

  private

    # Finds the user using the reset token
    def set_user_by_token
      # Retrieves the user with a valid password reset token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      # Redirects if the token is invalid or expired
      redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
    end
end
