require "test_helper"

class MinesweeperControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get minesweeper_index_url
    assert_response :success
  end
end
