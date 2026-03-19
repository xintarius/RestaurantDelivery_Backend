# history service
class HistoryService

  def self.generate_history_order(order, courier)
    vendor_address = order.vendor.user.address.full_address
    client_address = order.user.address.full_address
    payment = order.courier_payments.find { |p| p.courier_id == courier.id }
    earnings = payment&.gross_payment || 0

    ActiveRecord::Base.transaction do
      HistoryOrder.create!(
        order_id: order.id,
        courier_id: courier,
        vendor_id: order.vendor.id,
        restaurant_name: order.vendor.name,
        pickup_address: vendor_address,
        delivery_address: client_address,
        order_status: order.order_status,
        total_courier_earnings: earnings,
        base_earnings_data: nil
      )
    end
  end
end