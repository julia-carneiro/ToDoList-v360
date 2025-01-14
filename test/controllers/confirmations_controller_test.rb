require "test_helper"

class ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:unconfirmed)
    @user.update!(confirmation_token: SecureRandom.urlsafe_base64)
  end

  test "should confirm user when token is valid" do
    get edit_confirmation_url(token: @user.confirmation_token)

    assert_redirected_to new_session_path
    assert_equal "Your email has been confirmed. Please log in.", flash[:notice]

    @user.reload
    assert_nil @user.confirmation_token
  end

  test "should not confirm user when token is invalid" do
    get edit_confirmation_url(token: "invalid_token")

    assert_redirected_to root_path
    assert_equal "Invalid or already confirmed token.", flash[:alert]

    @user.reload
    assert_not_nil @user.confirmation_token
  end
end
