class UserMailer < ApplicationMailer
  def welcome_and_confirmation_email(user)
    @user = user
    @confirmation_link = Rails.application.routes.url_helpers.edit_confirmation_url(user.confirmation_token, host: "localhost", port: 3000)
    mail to: @user.email_address, subject: "Welcome to our platform! Please confirm your email"
  end
end
