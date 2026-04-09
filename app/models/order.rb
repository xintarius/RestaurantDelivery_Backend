# order model
class Order < ApplicationRecord
  belongs_to :user
  belongs_to :vendor
  has_many :order_products, dependent: :destroy
  accepts_nested_attributes_for :order_products
  has_many :courier_orders
  has_many :courier_payments
  has_many :couriers, through: :courier_orders
  has_many :products, through: :order_products
  before_create :generate_order_number
  after_create_commit :broadcast_to_vendor
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

  def product_name
    order_products.map do |op|
      "#{op.quantity}x #{op.product.product_name}"
    end.join(", ")
  end

  def total_price
    order_products.to_a.sum(&:total_price).to_f
  end

  def broadcast_to_vendor
    ActionCable.server.broadcast(
      "vendors_channel_#{self.vendor_id}",
      self.as_json(
        only: [ :id, :order_status, :order_number, :order_note_vendor, :estimated_delivery_time ],
        methods: [ :product_name, :total_price ]
      )
    )
  end

  private

  def generate_order_number
    self.order_number ||= "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(3).upcase}"
  end
end
