class CreateSupportTicket < ActiveRecord::Migration[8.0]
  def change
    create_table :support_tickets do |t|
      t.string :subject
      t.string :message
      t.string :status, default: "OPEN"
      t.references :courier
      t.references :user
      t.references :vendor

      t.timestamps
    end
  end
end
