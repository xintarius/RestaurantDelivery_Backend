# product model
class Product < ApplicationRecord
  belongs_to :vendor
  has_many :orders
  has_many :cart_products
  has_many :cart_summaries, through: :cart_products
  self.table_name = 'products'
end
