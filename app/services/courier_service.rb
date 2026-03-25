# courier service
class CourierService
  def initialize(courier, amount_cents, title, metadata = {})
    @courier = courier
    @amount_cents = amount_cents
    @title = title
    @metadata = metadata
  end

  def call
    ActiveRecord::Base.transaction do
      transaction = @courier.wallet_transactions.create!(
        amount_cents: @amount_cents,
        transaction_type: :income,
        title: @title,
        metadata: @metadata
      )
    @courier.with_lock do
      new_balance = @courier.current_balance + @amount_cents
      @courier.update!(current_balance: new_balance)
    end

    transaction
    end
  rescue => e
    Rails.logger.error "Błąd zliczania kwot dla kuriera #{@courier.id}: #{e.message}"
    false
  end
end
