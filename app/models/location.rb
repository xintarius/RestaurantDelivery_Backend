# location model
class Location < ApplicationRecord
  has_many :vendors
  has_many :addresses
end
