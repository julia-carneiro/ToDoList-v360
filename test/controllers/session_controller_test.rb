require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @unconfirmed_user = users(:unconfirmed)
    @confirmed_user = users(:one)
  end

  test "should not allow login for unconfirmed user" do
    # Attempts to log in with an unconfirmed user's credentials
    post session_path, params: { email_address: @unconfirmed_user.email_address, password: "password" }

    # Ensures the user is redirected to the login page
    assert_redirected_to new_session_path

    assert_equal "You need to confirm your email address before logging in.", flash[:alert]
  end

  test "should allow login for confirmed user" do
    # Verifies that a new session is created for the confirmed user
    assert_difference -> { @confirmed_user.sessions.count }, 1 do
      post session_path, params: { email_address: @confirmed_user.email_address, password: "password" }
    end

    # Ensures the user is redirected to the root path
    assert_redirected_to root_path

    # Fetches the latest session created for the confirmed user
    session = @confirmed_user.sessions.last
    assert session.present?, "Session was not created"

    # Validates the session's user agent and IP address
    assert_equal request.user_agent, session.user_agent
    assert_equal request.remote_ip, session.ip_address
  end

  test "should not allow login with invalid credentials" do
    # Attempts to log in with incorrect credentials
    post session_path, params: { email_address: @confirmed_user.email_address, password: "wrongpassword" }

    assert_response :unprocessable_entity

    assert_equal "Invalid email or password", flash[:alert]
  end
end
