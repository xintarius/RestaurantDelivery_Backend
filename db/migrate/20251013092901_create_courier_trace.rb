class CreateCourierTrace < ActiveRecord::Migration[8.0]
  def change
    create_table :courier_traces do |t|
      t.references :courier, foreign_key: true
      t.references :vendor, foreign_key: true
      t.references :order, foreign_key: true
      t.string :trace_from_start
      t.string :trace_to_collect_order
      t.string :trace_from_vendor
      t.string :trace_to_client
      t.timestamps
    end
  end
end
