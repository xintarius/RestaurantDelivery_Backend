# cart summary controller
class Api::CartSummariesController < ApplicationController

  def cart_summary
    cart_summaries = CartSummary.joins(:cart_products)
                                .where(user_id: current_user)
                                .select("cart_products.quantity as quantity,
                                cart_products.unit_price as price,
                                cart_products.total_price as total_price, cart_summaries.id as id,
                                gross_payment, net_payment")

    render json: cart_summaries
  end

  def get_cart_sum
    sum_cart = CartSummary.where(user_id: current_user).sum(:gross_payment).to_f.round(2)

    render json: { total: sprintf("%.2f", sum_cart) }
  end

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
