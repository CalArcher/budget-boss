require "test_helper"

class SheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sheet = sheets(:one)
  end

  test "should get index" do
    get sheets_url, as: :json
    assert_response :success
  end

  test "should create sheet" do
    assert_difference("Sheet.count") do
      post sheets_url, params: { sheet: { month: @sheet.month } }, as: :json
    end

    assert_response :created
  end

  test "should show sheet" do
    get sheet_url(@sheet), as: :json
    assert_response :success
  end

  test "should update sheet" do
    patch sheet_url(@sheet), params: { sheet: { month: @sheet.month } }, as: :json
    assert_response :success
  end

  test "should destroy sheet" do
    assert_difference("Sheet.count", -1) do
      delete sheet_url(@sheet), as: :json
    end

    assert_response :no_content
  end
end
