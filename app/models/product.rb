# product model
class Product < ApplicationRecord
  belongs_to :vendor
  has_many :cart_product
  has_many :cart_summaries, through: :cart_product
  has_many :order_product
  has_many :orders, through: :order_product
  self.table_name = 'products'

  def price_gross
    order_product.first&.unit_price
  end
end
