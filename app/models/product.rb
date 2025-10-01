# product model
class Product < ApplicationRecord
  belongs_to :vendor
  has_many :orders
  self.table_name = 'products'
end
