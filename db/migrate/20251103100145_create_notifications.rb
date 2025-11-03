class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.string :title
      t.string :description
      t.string :sender
      t.datetime :received_date
      t.boolean :read, default: false
      t.timestamps
    end
  end
end
