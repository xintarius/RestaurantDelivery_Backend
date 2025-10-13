class CreateCartSummary < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_summaries do |t|
      t.references :order, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :gross_payment
      t.integer :net_payment
      t.numeric :vat
      t.timestamps
    end
  end
end
