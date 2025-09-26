# vendor model
class Vendor < ApplicationRecord
  belongs_to :location
  has_many :products
  belongs_to :user
  belongs_to :address
end
