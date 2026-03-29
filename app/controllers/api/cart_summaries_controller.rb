# cart summary controller
class Api::CartSummariesController < ApplicationController

  def cart_summary
    per_page = params.fetch(:per_page, 8).to_i
    page = params.fetch(:page, 1).to_i
    per_user = CartSummary.where(user_id: current_user.id, order_id: nil)
    cart_summaries = CartSummary.limit(per_page).offset((page - 1) * per_page)
                                .joins(:cart_products)
                                .where(user_id: current_user, order_id: nil)
                                .select("cart_products.quantity as quantity,
                                cart_products.unit_price as price,
                                cart_products.total_price as total_price, cart_products.id as id,
                                gross_payment, net_payment")

    render json: { data: cart_summaries.as_json,
                   meta: {
                     current_page: page,
                     per_page: per_page,
                     total_records: per_user.count,
                     total_pages: (per_user.count / per_page .to_f).ceil
                   }
    }
  end

  def get_cart_sum
    sum_cart = CartSummary.where(user_id: current_user)
    cart_product = CartProduct.where(cart_summary_id: sum_cart).sum(:total_price).to_f.round(2)

    render json: { total: sprintf("%.2f", cart_product) }
  end

  def add_to_cart
    cart_summary = CartSummary.new(cart_summary_params)

    cart_summary.user_id = current_user.id

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
          .permit(:order_id, :user_id, :gross_payment, :net_payment, :vendor_id,
                  cart_products_attributes: [ :product_id, :quantity, :unit_price, :total_price ])
  end
end
