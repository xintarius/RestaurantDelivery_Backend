  class OrdersChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user

    courier = current_user.courier
    if courier
      orders = courier.orders.joins(:vendor)
                      .select('vendors.name as vendor_name, orders.order_status, orders.id as order_id')

      transmit({ type: "CURRENT_STATE", orders: orders })
  else
    transmit({ type: "CURRENT_STATE", orders: [] })
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
