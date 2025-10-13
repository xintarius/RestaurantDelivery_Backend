# order model
class Order < ApplicationRecord
  belongs_to :user
  belongs_to :vendor
  belongs_to :product
  has_many :order_product
  has_many :products, through: :order_product

  def products_list
    order_product.map do |op|
      {
        product_name: op.product.product_name,
        price_gross: op.unit_price,
        quantity: op.quantity,
        total_price: op.total_price
      }
    end
  end
end
