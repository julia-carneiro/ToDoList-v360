class ConfirmationsController < ApplicationController
  def edit
    user = User.find_by(confirmation_token: params[:confirmation_token])
    if user
      user.confirm! # Remove o confirmation_token
      redirect_to new_session_path, notice: "Your email has been confirmed. Please log in."
    else
      flash[:alert] = "Invalid or already confirmed token."
      redirect_to root_path
    end
  end
end
