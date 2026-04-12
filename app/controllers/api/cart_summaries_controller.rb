# cart summary controller
class Api::CartSummariesController < ApplicationController

  def cart_summary
    per_page = params.fetch(:per_page, 8).to_i
    page = params.fetch(:page, 1).to_i

    active_summaries = CartSummary.includes(:cart_products)
                                  .where(user_id: current_user.id, order_id: nil)
                                  .limit(per_page)
                                  .offset((page - 1) * per_page)
    formatted_data = active_summaries.map do |summary|
      {
        cart_summary_id: summary.id,
        vendor_id: summary.vendor_id,
        vendor_name: summary.vendor.name,
        gross_payment: summary.gross_payment,
        products: summary.cart_products.map do |cp|
          {
            cart_product_id: cp.id,
            product_id: cp.product_id,
            product_name: cp.product.product_name,
            quantity: cp.quantity,
            unit_price: cp.unit_price,
            total_price: cp.total_price
          }
        end
      }
    end
    render json: { data: formatted_data,
                   meta: {
                     current_page: page,
                     total_records: CartSummary.where(user_id: current_user.id, order_id: nil).count
                   }
    }
  end

  def get_cart_sum
    selected_ids = params[:selected_ids] || []

    return render json: { total: "0.00" } if selected_ids.empty?
    total = CartProduct.joins(:cart_summary)
                       .where(id: selected_ids, cart_summaries: { user_id: current_user.id, order_id: nil })
                       .sum(:total_price)

    render json: { total: sprintf("%.2f", total) }
  end

  def add_to_cart
    cart_summary = CartSummary.find_or_initialize_by(
      user_id: current_user.id,
      vendor_id: params[:cart_summary][:vendor_id],
      order_id: nil
    )

    new_gross = cart_summary_params[:gross_payment].to_f
    new_net = cart_summary_params[:net_payment].to_f
    cart_summary.gross_payment = (cart_summary.gross_payment || 0.0) + new_gross
    cart_summary.net_payment = (cart_summary.net_payment || 0.0) + new_net

    cart_summary.assign_attributes(
      cart_products_attributes: cart_summary_params[:cart_products_attributes]
    )

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
