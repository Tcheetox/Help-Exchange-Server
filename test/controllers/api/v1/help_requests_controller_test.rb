require 'test_helper'

class Api::V1::HelpRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get api_v1_help_requests_create_url
    assert_response :success
  end

end
