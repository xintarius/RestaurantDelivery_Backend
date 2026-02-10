class OrdersChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user

    courier = current_user.courier
    if courier
      orders_scope = courier.orders.includes(:courier_payments, vendor: { user: :address })
      orders_data = orders_scope.map do |order|
        payment = order.courier_payments.find { |p| p.courier_id == courier.id }
        vendor_address = order.vendor.user.address

        {
          order_id: order.id,
          order_number: order.order_number,
          order_status: order.order_status,
          vendor_name: order.vendor.name,
          vendor_street: vendor_address&.street,
          vendor_building: vendor_address&.building,
          vendor_apartment: vendor_address&.apartment,
          vendor_postal_code: vendor_address&.postal_code,
          vendor_city: vendor_address&.city,
          gross_payment: payment&.gross_payment
        }
      end
      transmit({ type: "CURRENT_STATE", orders: orders_data })
    else
      transmit({ type: "CURRENT_STATE", orders: [] })
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
