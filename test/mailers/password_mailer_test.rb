require "test_helper"

class PasswordsMailerTest < ActionMailer::TestCase
  test "reset email" do
    user = users(:one)
    email = PasswordsMailer.reset(user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ "julia.taskify@gmail.com" ], email.from
    assert_equal [ user.email_address ], email.to
    assert_equal "Reset your password", email.subject

    assert_match /You can reset your password on this password reset page:/, email.text_part.body.to_s
    assert_match /<a href="http:\/\/example.com\/passwords\/.*\/edit">this password reset page<\/a>/, email.html_part.body.to_s
  end
end
