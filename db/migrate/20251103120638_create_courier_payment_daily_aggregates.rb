class CreateCourierPaymentDailyAggregates < ActiveRecord::Migration[8.0]
  def change
    create_table :courier_payment_daily_aggregates do |t|
      t.references :calendars, foreign_key: true
      t.references :courier, foreign_key: true
      t.integer :delivery_count, default: 0
      t.decimal :sum_gross, precision: 10, scale: 2
      t.decimal :sum_net, precision: 10, scale: 2
      t.timestamps
    end
    add_index :courier_payment_daily_aggregates, [ :courier_id, :calendars_id ], unique: true
  end
end
