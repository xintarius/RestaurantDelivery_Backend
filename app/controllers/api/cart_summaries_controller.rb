# cart summary controller
class Api::CartSummariesController < ApplicationController

  def cart_summary
    cart_summaries = CartSummary.joins(:cart_products)
                                .where(user_id: current_user, order_id: nil)
                                .select("cart_products.quantity as quantity,
                                cart_products.unit_price as price,
                                cart_products.total_price as total_price, cart_products.id as id,
                                gross_payment, net_payment")

    render json: cart_summaries
  end

  def get_cart_sum
    sum_cart = CartSummary.where(user_id: current_user)
    cart_product = CartProduct.where(cart_summary_id: sum_cart).sum(:total_price).to_f.round(2)

    render json: { total: sprintf("%.2f", cart_product) }
  end

  def add_to_cart
    cart_summary = CartSummary.new(cart_summary_params)

    if cart_summary.save
      render json: cart_summary, include: :cart_products, status: :created
    else
      render json: { errors: cart_summary.errors.full_messages }, status: :no_content
    end
  end

  def cart_products
    cart_item = CartProduct.find_by!(id: params[:id])

    if cart_item.destroy
      render json: { message: "Usunięto pomyślnie" }, status: :ok
    else
      render json: { error: "Błąd usuwania" }, status: :unprocessable_entity
    end
  end

  private

  def cart_summary_params
    params.require(:cart_summary)
          .permit(:order_id, :user_id, :gross_payment, :net_payment,
                  cart_products_attributes: [ :product_id, :quantity, :unit_price, :total_price ])
  end
end
