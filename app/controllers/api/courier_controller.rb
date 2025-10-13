# courier_controller
class Api::CourierController < ApplicationController

  def courier_interface
    courier_order = Vendor.joins(:orders).select("vendors.name, orders.order_status as order_status")
    render json: courier_order
    end
end