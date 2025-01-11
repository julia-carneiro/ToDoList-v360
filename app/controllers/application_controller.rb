class ApplicationController < ActionController::Base
  before_action :require_login, except: [ :new, :create ]
  include Authentication
  allow_browser versions: :modern

  private

  def require_login
    redirect_to new_session_path, alert: "You must be logged in to access this page" unless authenticated?
  end
end
