require "test_helper"

class PexesoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pexeso_index_url
    assert_response :success
  end
end
