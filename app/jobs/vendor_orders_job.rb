# frozen_string_literal: true
class VendorOrdersJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.includes(:order_products).find_by!(id: order_id)

    return unless order

    ActionCable.server.broadcast(
      "vendors_channel_#{order.vendor_id}",
      order.as_json(include: :order_products)
    )
  end
end
