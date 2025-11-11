class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.string :city, null: false
      t.string :coc_number, null: false # unique Chamber of Commerce number

      # cached lowercase columns for case-insensitive search on SQLite
      t.string :name_lc, null: false
      t.string :city_lc, null: false

      t.timestamps
    end

    # Uniqueness at DB level
    add_index :companies, :coc_number, unique: true

    # Search helpers
    add_index :companies, :name_lc
    add_index :companies, :city_lc

    # Lightweight sanity constraints (SQLite supports CHECK)
    add_check_constraint :companies, "length(trim(coc_number)) > 0", name: "companies_coc_present"
  end
end