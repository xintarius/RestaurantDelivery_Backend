class AddUserForeignKeyToCouriers < ActiveRecord::Migration[8.0]
  def change
    add_reference :couriers, :user, foreign_key: true
  end
end
