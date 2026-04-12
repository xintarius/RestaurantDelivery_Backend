class AddCourierNumberToCouriers < ActiveRecord::Migration[8.0]
  def change
    add_column :couriers, :courier_number, :string
  end
end
