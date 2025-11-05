# orders controller
class Api::OrdersController < ApplicationController
  before_action :authenticate_user!
  def order_index
    orders = Order.includes(:order_products, :products).all

    render json: orders.as_json(only: [:id, :order_status, :order_number, :order_note_vendor], methods: [:products_list])
  end

  def create_order_from_cart
    cart = current_user.cart_summaries.last
    puts cart.inspect
    if cart.blank? || cart.cart_products.empty?
      return render json: { error: "Koszyk jest pusty" }, status: :unprocessable_entity
    end

    order = current_user.orders.create!(
      vendor_id: cart.cart_products.first.product.vendor_id,
      order_status: "created"
    )

    cart.cart_products.each do |cart_item|
      order.order_products.create!(
        product_id: cart_item.product_id,
        quantity: cart_item.quantity
      )
    end

    render json: order.as_json(
      include: {
        order_products: {
          include: { product: { only: [ :product_name, :price_gross ] } },
          only: [ :quantity ]
        }
      }
    ), status: :created
  end


  def active_client_orders
    active_client_order = Order.where(order_status: "Created", user_id: current_user.id).joins(:products).select('orders.order_status, products.product_name as product_name')
    render json: active_client_order
  end

  def finished_client_orders
    finished_client_order = Order.where(order_status: "finished", user_id: current_user.id).joins(:products).select('orders.order_status, products.product_name as product_name')
    render json: finished_client_order
  end

  def client_menu
    products_for_client = Product.select("id, product_name, file_path, description")
    render json: products_for_client
  end

  private

  def order_params
    params.require(:order).permit(
      :vendor_id,
      :order_status,
      :order_note_vendor,
      :order_number,
      :product_id,
      :quantity
    )
  end
end
