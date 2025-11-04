# cart summary controller
class Api::CartSummariesController < ApplicationController

  def add_to_cart
    cart_summary = CartSummary.new(cart_summary_params)

    if cart_summary.save
      render json: cart_summary, include: :cart_products, status: :created
    else
      render json: { errors: cart_summary.errors.full_messages }, status: :no_content
    end
  end

  private

  def cart_summary_params
    params.require(:cart_summary)
          .permit(:order_id, :user_id,
                  cart_products_attributes: [ :product_id, :quantity ])
  end
end
