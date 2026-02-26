# payment service
class PaymentService

  def self.pay_for_order(user, cart)
    order = nil
    ActiveRecord::Base.transaction do
      order = user.orders.create!(
        vendor_id: cart.cart_products.first.product.vendor_id,
        payment_status: "paid",
        order_status: "created"
      )

      cart.cart_products.each do |cart_item|
        order.order_products.create!(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity,
          unit_price: cart_item.unit_price,
          total_price: cart_item.total_price
        )
      end
    end
    order
  end
end
