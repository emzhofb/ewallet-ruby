require "test_helper"

class Api::V1::TransfersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_transfers_create_url
    assert_response :success
  end
end
