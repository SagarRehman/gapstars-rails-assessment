require "test_helper"

class Admin::CompaniesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_admin_company_url
    assert_response :success
  end

  test "should post create with valid file" do
    # This should be a POST request, not GET
    file = fixture_file_upload('companies.csv', 'text/csv')
    post admin_companies_url, params: { file: file }
    assert_redirected_to root_path
    assert_equal "Import completed.", flash[:notice]
  end

  test "should handle missing file" do
    post admin_companies_url, params: { file: nil }
    assert_redirected_to new_admin_company_path
    assert_equal "Please choose a CSV file.", flash[:alert]
  end
end
