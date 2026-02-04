  class OrdersChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user

    orders = Vendor.joins(:orders)
                   .select('vendors.name as vendor_name, orders.order_status, orders.id as order_id')
                   .where(orders: { courier_id: current_user.id })

    transmit({ type: "CURRENT_STATE", orders: orders })
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
