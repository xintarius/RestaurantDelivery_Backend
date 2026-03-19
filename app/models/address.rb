# address model
class Address < ApplicationRecord
  has_many :users
  belongs_to :location
  has_many :vendors

  def full_address
    [city, postal_code, postal_city, street, building, apartment]
      .select(&:present?)
      .join(', ')
  end
end
