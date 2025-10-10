# orders controller
class Api::OrdersController < ApplicationController

  def order_index
    orders = Order.joins(:product)
                        .select("orders.id, orders.order_status, orders.order_note_vendor,
                                        orders.order_number, products.product_name as product_name,
                                        products.price_gross as price_gross")
    render json: orders.as_json(only: [:id, :order_status, :order_number, :order_note_vendor], methods: [:product_name, :price_gross])
  end

  def create_order
    order = current_user.orders.new(order_params)
    if order.save
      render json: order, status: :created
    else
      render json: { errors: order.errors }, status: :unprocessable_entity
    end
  end

  def active_client_orders
    active_client_order = Order.where(order_status: "Created", user_id: current_user.id).joins(:product).select('orders.order_status, products.product_name as product_name')
    render json: active_client_order
  end

  def finished_client_orders
    finished_client_order = Order.where(order_status: "finished", user_id: current_user.id).joins(:product).select('orders.order_status, products.product_name as product_name')
    render json: finished_client_order
  end

  private

  def order_params
    params.require(:order).permit(:vendor_id, :product_id, :order_status, :order_note_vendor, :order_number)
  end
end
