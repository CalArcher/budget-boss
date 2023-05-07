require "test_helper"

class UserCommandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_command = user_commands(:one)
  end

  test "should get index" do
    get user_commands_url, as: :json
    assert_response :success
  end

  test "should create user_command" do
    assert_difference("UserCommand.count") do
      post user_commands_url, params: { user_command: { body: @user_command.body } }, as: :json
    end

    assert_response :created
  end

  test "should show user_command" do
    get user_command_url(@user_command), as: :json
    assert_response :success
  end

  test "should update user_command" do
    patch user_command_url(@user_command), params: { user_command: { body: @user_command.body } }, as: :json
    assert_response :success
  end

  test "should destroy user_command" do
    assert_difference("UserCommand.count", -1) do
      delete user_command_url(@user_command), as: :json
    end

    assert_response :no_content
  end
end
