# courier_controller
class Api::CourierController < ApplicationController

  def courier_interface
    courier_order = Vendor.joins(:orders)
                          .select("vendors.name as vendor_name, orders.order_status as order_status, orders.id as order_id")
    cur_user = User.find(params[:courier_id])

    OrdersChannel.broadcast_to(cur_user, { type: "REFRESH_ORDERS", orders: courier_order })

    render json: courier_order
    end
end
