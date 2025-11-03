# order_products
class OrderProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  self.table_name = "order_products"
end
