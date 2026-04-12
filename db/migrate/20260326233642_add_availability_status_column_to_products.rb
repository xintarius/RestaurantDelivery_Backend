class AddAvailabilityStatusColumnToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :availability_status, :string, default: 'inactive'
  end
end
