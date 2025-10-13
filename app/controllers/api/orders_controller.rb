# orders controller
class Api::OrdersController < ApplicationController
  before_action :authenticate_user!
  def order_index
    orders = Order.includes(:order_product, :product).all

    render json: orders.as_json(only: [:id, :order_status, :order_number, :order_note_vendor], methods: [:products_list])
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
    params.require(:order).permit(:vendor_id, :order_status, :order_note_vendor, :order_number)
  end
end
