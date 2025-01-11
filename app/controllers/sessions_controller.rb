class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    user = User.find_by(email_address: params[:email_address])

    if user&.authenticate(params[:password])
      start_new_session_for(user)
      redirect_to after_authentication_url
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session if authenticated?
    redirect_to root_path, notice: "Logged out!"
  end
end