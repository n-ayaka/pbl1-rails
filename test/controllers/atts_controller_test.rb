require 'test_helper'

class AttsControllerTest < ActionDispatch::IntegrationTest
  test "should get change" do
    get atts_change_url
    assert_response :success
  end

end
