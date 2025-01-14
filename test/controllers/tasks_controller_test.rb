require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @list = lists(:one)
    @other_list = lists(:two)
    @task = tasks(:one)
    @other_task = tasks(:two)
    @user = users(:one)
    sign_in_as(@user) # Simulates signing in as the user
    follow_redirect! # Ensures any redirects after login are followed
  end

  test "should get index of tasks" do
    get list_tasks_url(@list)
    assert_response :success
  end

  test "should not get index of other user's list tasks" do
    get list_tasks_url(@other_list)
    assert_redirected_to lists_url
    assert_equal "You don't have access to this list", flash[:alert]
  end

  test "should create task" do
    assert_difference("Task.count") do
      post list_tasks_url(@list), params: {
        task: { title: "New Task", completed: false }
      }
    end
    assert_redirected_to list_tasks_url(@list)
  end

  test "should not create task in other user's list" do
    assert_no_difference("Task.count") do
      post list_tasks_url(@other_list), params: {
        task: { title: "New Task", completed: false }
      }
    end
    assert_redirected_to lists_url
    assert_equal "You don't have access to this list", flash[:alert]
  end

  test "should update own task" do
    patch list_task_url(@list, @task), params: {
      task: { title: "Updated Task" }
    }

    assert_redirected_to list_task_url(@list, @task)
    @task.reload
    assert_equal "Updated Task", @task.title
  end

  test "should update task completion status" do
    # To test turbo_stream
    patch list_task_url(@list, @task), params: { completed: "true" },
          headers: { "Accept" => "text/vnd.turbo-stream.html" }
    assert_response :success
    @task.reload
    assert @task.completed
  end

  test "should not update task in other user's list" do
    patch list_task_url(@other_list, @other_task), params: {
      task: { title: "Updated Task" }
    }
    assert_redirected_to lists_url
    assert_equal "You don't have access to this list", flash[:alert]
  end

  test "should destroy task" do
    assert_difference("Task.count", -1) do
      delete list_task_url(@list, @task)
    end
    assert_redirected_to list_tasks_url(@list)
  end

  test "should not destroy task in other user's list" do
    assert_no_difference("Task.count") do
      delete list_task_url(@other_list, @other_task)
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
