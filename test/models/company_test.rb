require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  test "validations and uniqueness" do
    Company.create!(name: "Beequip", city: "Rotterdam", coc_number: "123", name_lc: "beequip", city_lc: "rotterdam")
    assert_raises ActiveRecord::RecordInvalid do
      Company.create!(name: "Other", city: "RTM", coc_number: "123", name_lc: "other", city_lc: "rtm")
    end
  end

  test "search_sql matches name, city and coc_number" do
    Company.create!(name: "Beequip", city: "Rotterdam", coc_number: "123", name_lc: "beequip", city_lc: "rotterdam")
    Company.create!(name: "Acme",    city: "Berlin",    coc_number: "BE-777", name_lc: "acme",    city_lc: "berlin")

    assert_equal 2, Company.search_sql("be").count
    assert_equal 1, Company.search_sql("123").count
  end
end