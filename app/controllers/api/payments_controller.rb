# app/controllers/api/payments_controller.rb
class Api::PaymentsController < ApplicationController
  def user_payment
    cart_summary = current_user.cart_summaries.order(created_at: :desc).first
    Rails.logger.info "CART SUMMARY: #{cart_summary.inspect}"

    unless cart_summary&.gross_payment
      render json: { error: "Brak danych o koszyku lub kwocie płatności." }, status: :unprocessable_content
      return
    end

    if current_user.stripe_customer_id.blank?
      customer = Stripe::Customer.create({
                                           email: current_user.email,
                                           name: current_user.username
                                         })
      current_user.update!(stripe_customer_id: customer.id)
    end

    payment_intent = Stripe::PaymentIntent.create(
      amount: (cart_summary.gross_payment * 100).to_i, # kwota w groszach
      currency: "pln",
      customer: current_user.stripe_customer_id,
      setup_future_usage: "off_session",
      metadata: {
        user_id: current_user.id,
        cart_summary_id: cart_summary.id
      }
    )

    render json: { client_secret: payment_intent.client_secret }

  rescue Stripe::StripeError => e
    Rails.logger.error "STRIPE ERROR: #{e.message}"
    render json: { error: e.message }, status: :unprocessable_content

  rescue => e
    Rails.logger.error "APP ERROR: #{e.message}"
    render json: { error: e.message }, status: :unprocessable_content
  end

  def webhook
    payload = request.body.read
    event = nil

    begin
      event = Stripe::Event.construct_from(JSON.parse(payload, symbolize_names: true))
    rescue JSON::ParserError => e
      render json: { error: "Invalid payload" }, status: 400 and return
    end

    case event.type
    when 'payment_intent.succeeded'
      payment_intent = event.data.object
      user = User.find_by(id: payment_intent.metadata.user_id)

      if user && payment_intent.payment_method
        pm = Stripe::PaymentMethod.retrieve(payment_intent.payment_method)

        user.update!(
          stripe_payment_method_id: pm.id
        )

        Rails.logger.info "Zapisano dane karty dla użytkownika ##{user.id}"
      end
    end

    render json: { message: 'success' }
  end
end
