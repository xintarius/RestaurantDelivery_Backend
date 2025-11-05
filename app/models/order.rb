# order model
class Order < ApplicationRecord
  belongs_to :user
  belongs_to :vendor
  has_many :order_products, dependent: :destroy
  accepts_nested_attributes_for :order_products
  has_many :courier_orders
  has_many :couriers, through: :courier_orders
  has_many :products, through: :order_products

  before_create :generate_order_number
  def products_list
    order_products.map do |op|
      {
        product_name: op.product.product_name,
        price_gross: op.unit_price,
        quantity: op.quantity,
        total_price: op.total_price
      }
    end
  end

  private

  def generate_order_number
    self.order_number ||= "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(3).upcase}"
  end
end
