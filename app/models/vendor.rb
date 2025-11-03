# vendor model
class Vendor < ApplicationRecord
  has_many :products
  has_many :orders
  belongs_to :user
  belongs_to :address

  self.table_name = "vendors"
end
