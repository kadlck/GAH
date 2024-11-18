require "test_helper"

class SudokuControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sudoku_index_url
    assert_response :success
  end
end
