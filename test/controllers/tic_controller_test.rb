require "test_helper"

class TicControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tic_index_url
    assert_response :success
  end
end
