require 'test_helper'

class VpnControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get vpn_index_url
    assert_response :success
  end

end
