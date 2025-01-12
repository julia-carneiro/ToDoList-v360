class ConfirmationsController < ApplicationController
  allow_unauthenticated_access only: [ :edit ]
  def edit
    user = User.find_by(confirmation_token: params[:token])
    if user
      user.confirm!
      redirect_to new_list_path, notice: "Your email has been confirmed. Please log in."
    else
      flash[:alert] = "Invalid or already confirmed token."
      redirect_to root_path
    end
  end
end
