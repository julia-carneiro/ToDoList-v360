class SessionsController < ApplicationController
  # Redirects users to the lists page if logged in (custom method defined in authentication.rb)
  redirect_user_to_lists only: %i[ new create ]

  allow_unauthenticated_access only: %i[ new create ]

  # Limits the rate of requests to the `create` action to 10 requests within 3 minutes
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    # Renders the `new` view
  end

  # Handles user login
  def create
    # Finds the user by email address
    user = User.find_by(email_address: params[:email_address])

    # Authenticates the user with the provided password
    if user&.authenticate(params[:password])
      # Checks if the user's email needs confirmation
      if user.confirmation_token.present?
        flash[:alert] = "You need to confirm your email address before logging in."
        redirect_to new_session_path
      else
        # Initiates a new session for the user upon successful authentication
        start_new_session_for(user)
        redirect_to after_authentication_url
      end
    else
      # Renders the login form again with an error message on authentication failure
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  # Logs out the user
  def destroy
    # Terminates the current user session if authenticated
    terminate_session if authenticated?

    # Redirects to the root path after logging out
    redirect_to root_path
  end
end
