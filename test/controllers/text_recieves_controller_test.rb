require "test_helper"

class TextRecievesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @text_reciefe = text_recieves(:one)
  end

  test "should get index" do
    get text_recieves_url, as: :json
    assert_response :success
  end

  test "should create text_reciefe" do
    assert_difference("TextRecieve.count") do
      post text_recieves_url, params: { text_reciefe: { body: @text_reciefe.body } }, as: :json
    end

    assert_response :created
  end

  test "should show text_reciefe" do
    get text_reciefe_url(@text_reciefe), as: :json
    assert_response :success
  end

  test "should update text_reciefe" do
    patch text_reciefe_url(@text_reciefe), params: { text_reciefe: { body: @text_reciefe.body } }, as: :json
    assert_response :success
  end

  test "should destroy text_reciefe" do
    assert_difference("TextRecieve.count", -1) do
      delete text_reciefe_url(@text_reciefe), as: :json
    end

    assert_response :no_content
  end
end
