require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: {
        email_address: "new@example.com",
        password: "password123",
        password_confirmation: "password123",
        username: "newuser"
      } }
    end
    assert_redirected_to new_session_url
    assert_equal "Please check your email to confirm your account.", flash[:notice]
  end

  test "should not create user with existing email" do
    existing_user = users(:one)
    assert_no_difference("User.count") do
      post users_url, params: { user: {
        email_address: existing_user.email_address,
        password: "password123",
        password_confirmation: "password123",
        username: "newuser"
      } }
    end
    assert_response :unprocessable_entity
    assert_equal "E-mail already registered. Please, try another address.", flash[:alert]
  end

  test "should not create user with mismatched passwords" do
    assert_no_difference("User.count") do
      post users_url, params: { user: {
        email_address: "new@example.com",
        password: "password123",
        password_confirmation: "different",
        username: "newuser"
      } }
    end
    assert_response :unprocessable_entity
    assert_equal "Passwords did not match.", flash[:alert]
  end
end
