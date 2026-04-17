# orders controller
class Api::OrdersController < Api::ApplicationController
  before_action :authenticate_user!
  def vendor_orders
    per_page = params.fetch(:per_page, 10).to_i
    page = params.fetch(:page, 1).to_i
    orders = Order.limit(per_page).offset((page - 1) * per_page)
                  .includes(:order_products, :products)
                  .where(vendor_id: current_vendor)
                  .where.not(order_status: "delivered")
                  .where.not(order_status: "rejected")

    render json: { data: orders.as_json(only: [ :id, :order_status, :order_number, :order_note_vendor, :estimated_delivery_time ],
                   methods: [ :product_name, :total_price ]),
                   meta: {
                     current_page: page,
                     per_page: per_page
                   } }
  end

  def accept
    order = Order.find_by(id: params[:id], vendor_id: current_vendor)

    render json: { error: "Nie odnaleziono zamówienia" }, status: :not_found unless order

    minutes = params[:delivery_time_minutes].to_i

    if order.update(
      order_status: "accepted",
      estimated_delivery_time: Time.current + minutes.minutes
    )
    order.broadcast_to_vendor
    render json: { message: "Zamówienie zaakceptowane" }, status: :ok
    else
    render json: { error: order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def reject
    order = Order.find_by(id: params[:id], vendor_id: current_vendor)

    render json: { error: "nie odnaleziono zamówienia" }, status: :not_found unless order

    if order.update(
      order_status: "rejected",
      reject_reason: params[:reject_reason]
    )
      order.broadcast_to_vendor

      render json: { message: "Zamówienie odrzucone" }, status: :ok
    else
      render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def create_order_from_cart
    selected_order_ids = params[:selected_cart_product_ids]

    return render json: { error: "Nie wybrano żadnych produktów" }, status: :bad_request if selected_order_ids.blank?

    cart_products = CartProduct.includes(:cart_summary)
                               .where(id: selected_order_ids, cart_summaries: { user_id: current_user.id, order_id: nil })
    return render json: { error: "Koszyk jest pusty" }, status: :not_found if cart_products.empty?

    created_orders = []

    grouped_products = cart_products.group_by(&:cart_summary)
    grouped_products.each do |cart, products|
      order = PaymentService.pay_for_order(current_user, cart, products)
      order.broadcast_to_vendor
      search_for_courier(order)
      created_orders << order
    end
    render_respond(created_orders)
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def ready
    order = Order.find_by(id: params[:id], vendor_id: current_vendor)

    if order.update(order_status: "ready")
      order.broadcast_to_vendor
      render json: { message: "Zamówienie gotowe do odbioru" }, status: :ok
    else
      render json: { errors: order.errors.full_messages }, status: :unprocessable_entity
    end
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
    target_vendor_id = params[:vendor_id]
    products_for_client = Product.where(vendor_id: target_vendor_id)
                                 .select("id, vendor_id, product_name, file_path, description, price_gross")
    render json: products_for_client
  end

  private

  def search_for_courier(order)
    courier = Courier.find(1)

    if courier
      CourierOrder.create!(order: order, courier: courier)
    end
  end

  def render_respond(orders)
    render json: {
      message: "Zamówienie złożone pomyślnie",
      orders: orders.as_json(
        include: {
          order_products: {
            include: { product: { only: [ :product_name, :price_gross ] } },
            only: [ :quantity ]
          }
        }
      )
    }, status: :created
  end

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
