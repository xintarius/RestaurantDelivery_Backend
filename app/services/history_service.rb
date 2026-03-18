# history service
class HistoryService

  def self.generate_history_order(order, courier)
    vendor_address = order.vendor.user.address

    ActiveRecord::Base.transaction do
      HistoryOrder.create!(
        order_id: order.id,
        courier_id: courier,
        vendor_id: order.vendor.id,
        restaurant_name: order.vendor.name,
        pickup_address: vendor_address,
        delivery_address: order.user.address,
        order_status: order.order_status,
        total_courier_earnings: order.total_courier_earnings,
        base_earnings_data: nil
      )
    end
  end
end