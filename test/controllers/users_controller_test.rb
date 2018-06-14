require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get add" do
    get users_add_url
    assert_response :success
  end

end
