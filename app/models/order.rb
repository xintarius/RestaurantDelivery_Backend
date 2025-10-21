# order model
class Order < ApplicationRecord
  belongs_to :user
  belongs_to :vendor
  has_many :order_products, dependent: :destroy
  accepts_nested_attributes_for :order_products
  has_many :courier_orders
  has_many :couriers, through: :courier_orders
  has_many :products, through: :order_products

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
