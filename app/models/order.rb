# order model
class Order < ApplicationRecord
  belongs_to :user
  belongs_to :vendor
  has_many :order_products, dependent: :destroy
  accepts_nested_attributes_for :order_products
  has_many :courier_orders
  has_many :couriers, through: :courier_orders
  has_many :products, through: :order_products

  after_commit :broadcast_to_courier
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

  def as_json_for_cable
    {
      order_id: self.id,
      vendor_name: self.vendor_name,
      order_status: self.status,
      address: self.address
    }
  end

  private

  def broadcast_to_courier
    if destroyed? || user_id_previously_changed?
      old_user_id = user_id_previously_was || user_id

      old_user = User.find_by(id: old_user_id)

      if old_user
        OrdersChannel.broadcast_to(old_user, {
          type: 'DELETE_ORDER',
          order_id: self.id
        })
      end
    else
      OrdersChannel.broadcast_to(self.user, {
        type: 'NEW_ORDER',
        order: self.as_json_for_cable
      })
    end
  end

  def generate_order_number
    self.order_number ||= "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(3).upcase}"
  end
end
