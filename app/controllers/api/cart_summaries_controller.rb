# cart summary controller
class Api::CartSummariesController < ApplicationController

  def add_to_cart
    add_order = CartSummary.new(strong_params)
    if add_order.save
      render json: add_order, status: 200
    else
      render json: { errors: add_order.errors }, status: :no_content
    end
  end

  private

  def strong_params
    params.require(:cart_summary).permit(:order_id, :user_id)
  end
end