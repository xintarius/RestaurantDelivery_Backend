# vendor model
class Vendor < ApplicationRecord
  belongs_to :user
  belongs_to :address
  belongs_to :category_type
  has_many :products
  has_many :orders
  has_many :cart_summaries

  self.table_name = "vendors"
end
