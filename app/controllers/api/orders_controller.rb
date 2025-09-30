# orders controller
class Api::OrdersController < ApplicationController

  def order_index
    render json: { orders: Order.all }
  end

  def create_order
    order = current_user.orders.new(order_params)
    if order.save
      render json: order, status: :created
    else
      render json: { errors: order.errors }, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(:vendor_id, :product_id, :user_id, :order_status, :order_note_vendor, :order_number)
  end
end
