# address model
class Address < ApplicationRecord
  has_many :users
  belongs_to :location
  has_many :vendors
end
