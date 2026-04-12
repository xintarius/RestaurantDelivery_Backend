# payment service
class PaymentService

  def self.pay_for_order(user, cart, selected_cart_products)
    order = nil
    ActiveRecord::Base.transaction do
      order = user.orders.create!(
        vendor_id: cart.vendor_id,
        payment_status: "paid",
        order_status: "created"
      )

      selected_cart_products.each do |cart_item|
        order.order_products.create!(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity,
          unit_price: cart_item.unit_price,
          total_price: cart_item.total_price
        )
        cart_item.destroy!
      end
      cart.destroy! if cart.cart_products.reload.empty?
    end
    order
  end
end
