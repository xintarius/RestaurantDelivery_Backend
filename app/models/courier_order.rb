# class courier_order
class CourierOrder < ApplicationRecord
  belongs_to :courier
  belongs_to :order

  after_commit :alert_courier_about_new_order, on: :create

  private

  def alert_courier_about_new_order

    if courier&.user
      Rails.logger.info "Wysyłam zamówienie do kuriera #{order.id}"
      OrdersChannel.broadcast_to(courier.user, {
        type: "NEW_ORDER",
        order: {
          order_id: order.id,
          vendor_name: order.vendor&.name,
          order_status: order.order_status
        }
      })
    end
  end
end
