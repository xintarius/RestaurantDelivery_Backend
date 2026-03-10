# app/channels/orders_channel.rb
class OrdersChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user

    courier = current_user.courier
    return transmit({ type: 'ERROR', message: "Profil kuriera już istnieje"}) unless courier

    active_order = courier.orders.where(order_status: ["ACCEPTED", "IN_DELIVERY"]).first
    if active_order
      puts ">>>> SUBSKRYPCJA: Kurier #{courier.id} ma aktywne zamówienie #{active_order.id}"
      type = active_order.order_status == "IN_DELIVERY" ? "ORDER_IN_DELIVERY" : "ORDER_ACCEPTED"

      transmit({
                 type: type,
                 order: format_order_details(active_order, courier)
               })
    else
      send_available_orders(courier)
    end
  end

  def send_available_orders(courier)
    orders_scope = Order.where(order_status: 'created').limit(1)
    orders_data = orders_scope.map { |o| format_order_details(o, courier) }
    transmit({ type: "CURRENT_STATE", orders: orders_data })
  end

  def accept_order(data)
    puts ">>>> PRÓBA AKCEPTACJI ID: #{data['order_id']}"

    courier = current_user&.courier
    order = Order.find_by(id: data['order_id'])

    if order && order.order_status == 'created'
      begin
        ActiveRecord::Base.transaction do
          courier.orders << order unless courier.orders.include?(order)

          order.update!(order_status: 'ACCEPTED')
        end
        details = format_order_details(order, courier)
        transmit({ type: "ORDER_ACCEPTED", order: details })

        puts ">>>> SUKCES: Powiązano kuriera #{courier.id} z zamówieniem #{order.id}"

        ActionCable.server.broadcast("available_orders", {
          type: "DELETE_ORDER",
          order_id: order.id
        })
      rescue => e
        puts ">>>> BŁĄD RELACJI: #{e.message}"
        transmit({ type: "ERROR", message: "Błąd przypisania: #{e.message}" })
      end
    else
      puts ">>>> STATUS NIEOCZEKIWANY: #{order&.order_status}"
      transmit({ type: "ERROR", message: "Zamówienie już nie jest dostępne (Status: #{order&.order_status})" })
    end
  end

  def pickup_order(data)
    puts ">>>> PRÓBA PRZEKAZANIA W DOSTAWE DO KLIENTA ZAMÓWIENIA O ID: #{data['order_id']}"

    courier = current_user&.courier
    order = Order.find_by(id: data['order_id'])

    if order && order.order_status == 'ACCEPTED'
      order.update!(order_status: 'IN_DELIVERY')
      details = format_client_details(order, courier)
      transmit({ type: "ORDER_IN_DELIVERY", order: details })

      puts ">>>> SUKCES: KURIER O id #{courier.id} jedzie z zamówieniem #{order.id}"
    else
      puts ">>>> STATUS NIEOCZEKIWANY: #{order&.order_status}"
      transmit({ type: "ERROR", message: "Zamówienie już nie jest dostępne (Status: #{order&.order_status})" })
    end
  end

  def complete_delivery(data)
    order = Order.find_by(id: data['order_id'])
    courier = current_user.courier

    if order && order.order_status == 'IN_DELIVERY'
      order.update!(order_status: 'delivered')
      transmit({ type: "DELIVERY_COMPLETED" })
      orders_scope = Order.where(order_status: 'created').limit(1)
      orders_data = orders_scope.map { |o| format_order_details(o, courier) }
      transmit({ type: "CURRENT_STATE", orders: orders_data })
      puts ">>>> ZAKOŃCZONO: Zamówienie #{order.id} zostało dostarczone!"
    end
  end
  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def format_order_details(order, courier)
    payment = order.courier_payments.find { |p| p.courier_id == courier.id }
    vendor_address = order.vendor.user.address

    {
      order_id: order.id,
      order_number: order.order_number,
      order_status: order.order_status,
      vendor_name: order.vendor.name,
      vendor_street: vendor_address&.street,
      vendor_building: vendor_address&.building,
      vendor_apartment: vendor_address&.apartment,
      vendor_postal_code: vendor_address&.postal_code,
      vendor_city: vendor_address&.city,
      gross_payment: payment&.gross_payment
    }
  end

  def format_client_details(order, courier)
    payment = order.courier_payments.find { |p| p.courier_id == courier.id }
    user_address = order.user.address

    {
      order_id: order.id,
      order_number: order.order_number,
      order_status: order.order_status,
      vendor_name: order.user.username,
      vendor_street: user_address&.street,
      vendor_building: user_address&.building,
      vendor_apartment: user_address&.apartment,
      vendor_postal_code: user_address&.postal_code,
      vendor_city: user_address&.city,
      gross_payment: payment&.gross_payment
    }
  end
end
