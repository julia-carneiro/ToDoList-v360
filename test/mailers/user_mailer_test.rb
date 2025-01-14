require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "welcome_and_confirmation_email" do
    user = users(:unconfirmed)

    email = UserMailer.welcome_and_confirmation_email(user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "julia.taskify@gmail.com" ], email.from
    assert_equal [ user.email_address ], email.to
    assert_equal "Welcome to Taskify! Please confirm your email", email.subject

    assert_match "<h1>Welcome, Unconfirmed!</h1>", email.body.encoded
    assert_match "Thank you for signing up for Taskify.", email.body.encoded
    assert_match "Please confirm your email by clicking the link below:", email.body.encoded
    assert_match "Confirm your email", email.body.encoded
    assert_match "http://taskify.juserdev.com/confirm/#{user.confirmation_token}", email.body.encoded
  end
end
