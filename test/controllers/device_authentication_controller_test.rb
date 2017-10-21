require 'test_helper'

class DeviceAuthenticationControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get device_authentication_new_url
    assert_response :success
  end

end
