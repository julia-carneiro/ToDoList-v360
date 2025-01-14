require "test_helper"

class ListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @list = lists(:one)
    @other_user_list = lists(:two)
    @user = users(:one)
    @other_user = users(:two)
    sign_in_as(@user)
    follow_redirect!
  end

  test "should get index" do
    get lists_url
    assert_response :success
  end

  test "should create list for logged-in user" do
    assert_difference("List.count") do
      post lists_url, params: { list: { name: "My new list" } }
    end
    assert_redirected_to list_url(List.last)
  end

  test "should update user's own list" do
    patch list_url(@list), params: { list: { name: "Updated List" } }
    assert_redirected_to list_url(@list)
    @list.reload
    assert_equal "Updated List", @list.name
  end

  test "should not update other user's list" do
    patch list_url(@other_user_list), params: { list: { name: "Updated List" } }
    assert_redirected_to lists_url
    assert_equal "You don't have access to this list", flash[:alert]
  end

  test "should destroy user's own list" do
    assert_difference("List.count", -1) do
      delete list_url(@list)
    end
    assert_redirected_to lists_url
  end

  test "should not destroy other user's list" do
    assert_no_difference("List.count") do
      delete list_url(@other_user_list)
    end
    assert_redirected_to lists_url
    assert_equal "You don't have access to this list", flash[:alert]
  end

  private

  def sign_in_as(user)
    post session_path, params: { email_address: user.email_address, password: "password" }
    assert_response :redirect
  end
end
