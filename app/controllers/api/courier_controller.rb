# courier_controller
class Api::CourierController < ApplicationController

  def courier_interface
    courier_order = Vendor.joins(:orders).select("vendors.name as vendor_name, orders.order_status as order_status, orders.id as order_id")
    render json: courier_order
    end
end
