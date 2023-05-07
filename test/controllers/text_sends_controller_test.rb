require "test_helper"

class TextSendsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @text_send = text_sends(:one)
  end

  test "should get index" do
    get text_sends_url, as: :json
    assert_response :success
  end

  test "should create text_send" do
    assert_difference("TextSend.count") do
      post text_sends_url, params: { text_send: { body: @text_send.body } }, as: :json
    end

    assert_response :created
  end

  test "should show text_send" do
    get text_send_url(@text_send), as: :json
    assert_response :success
  end

  test "should update text_send" do
    patch text_send_url(@text_send), params: { text_send: { body: @text_send.body } }, as: :json
    assert_response :success
  end

  test "should destroy text_send" do
    assert_difference("TextSend.count", -1) do
      delete text_send_url(@text_send), as: :json
    end

    assert_response :no_content
  end
end
