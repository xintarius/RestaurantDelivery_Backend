# payment service
class PaymentService
  def self.pay_for_order(user, cart)
    ActiveRecord::Base.transaction do
      order = user.orders.create!(
        vendor_id: cart.cart_products.first.product.vendor_id,
        order_status: "created",
        unit_price: cart.unit_price,
        total_price: cart.total_price
      )

      cart.cart_products.each do |cart_item|
        order.order_products.create!(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity,
          unit_price: cart_item.unit_price,
          total_price: cart_item.total_price
        )
      end

      courier = Courier.find(1)

      if courier
        CourierOrder.create!(order: order, courier: courier)
      end
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
end
