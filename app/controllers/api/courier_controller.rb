# courier_controller
class Api::CourierController < Api::ApplicationController

  def courier_profile
    couriers_data = User.joins(:address, :courier)
                        .select('users.email, users.username, users.name,
                        users.last_name, users.phone_number, users.created_at,
                        addresses.city as city, addresses.postal_code as postal_code,
                        couriers.courier_number as courier_number')
                        .find(current_user.id)
    render json: couriers_data
  end

  def courier_interface
    courier_order = Vendor.joins(:orders)
                          .select("vendors.name as vendor_name, orders.order_status as order_status, orders.id as order_id")
    cur_user = User.find(params[:courier_id])

    OrdersChannel.broadcast_to(cur_user, { type: "REFRESH_ORDERS", orders: courier_order })

    render json: courier_order
  end

  def history_data
    orders_data = HistoryOrder.where(courier_id: current_courier)
                              .select("id, restaurant_name, pickup_address, delivery_address,
                              total_courier_earnings, order_status")

    render json: orders_data
  end
end
