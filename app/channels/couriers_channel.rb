# couriers channel
class CouriersChannel < ApplicationCable::Channel

  def subscribed
    stream_for current_user
    courier = current_user.courier

    courier_earnings = CourierPayment.where(courier_id: courier.id).sum(:gross_payment)

    transmit({
               type: "EARNINGS",
               earnings: courier_earnings
             })
  end

  def unsubscribed

  end
end
