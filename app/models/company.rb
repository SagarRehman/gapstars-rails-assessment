class Company < ApplicationRecord
  # Validations
  validates :name, :city, :coc_number, presence: true
  validates :coc_number, uniqueness: true

  # Normalize cached lowercase columns
  before_validation do
    self.name_lc = name.to_s.downcase
    self.city_lc = city.to_s.downcase
  end

  # Pure SQL search (no in-memory filtering)
  scope :search_sql, ->(q) do
    next all if q.blank?
    q = q.downcase
    where(
      "name_lc LIKE :q OR city_lc LIKE :q OR coc_number LIKE :q_exact",
      q: "%#{q}%",
      q_exact: "%#{q}%"
    ).order(:name)
  end
end