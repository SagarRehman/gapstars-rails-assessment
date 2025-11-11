require "test_helper"

class Admin::ImportsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_imports_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_imports_create_url
    assert_response :success
  end
end
