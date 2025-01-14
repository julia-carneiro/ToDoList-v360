class ApplicationController < ActionController::Base
  include Authentication
  allow_browser versions: :modern

  def not_found
    redirect_to root_path
  end
end
