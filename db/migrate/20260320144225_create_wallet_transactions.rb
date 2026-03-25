class CreateWalletTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :wallet_transactions do |t|
      t.references :courier
      t.integer :amount
      t.integer :transaction_type
      t.string :title
      t.jsonb :metadata
      t.timestamps
    end
  end
end
