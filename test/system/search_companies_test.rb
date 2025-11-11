require "application_system_test_case"

class SearchCompaniesTest < ApplicationSystemTestCase
  test "progressive search renders results" do
    Company.create!(name: "Beequip", city: "Rotterdam", coc_number: "123", name_lc: "beequip", city_lc: "rotterdam")

    visit root_path
    assert_text "Start typing"

    find("input[placeholder*='Type']").fill_in(with: "Be")
    assert_text "Beequip"
  end
end