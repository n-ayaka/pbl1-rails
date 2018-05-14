require 'test_helper'

class AttsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get atts_index_url
    assert_response :success
  end

  test "should get show" do
    get atts_show_url
    assert_response :success
  end

end
