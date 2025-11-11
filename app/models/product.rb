# product model
class Product < ApplicationRecord
  belongs_to :vendor
  has_many :cart_product
  has_many :cart_summaries, through: :cart_product
  has_many :order_products
  has_many :orders, through: :order_products
  self.table_name = "products"

  def order_price_gross
    order_products.first&.unit_price
  end
end
