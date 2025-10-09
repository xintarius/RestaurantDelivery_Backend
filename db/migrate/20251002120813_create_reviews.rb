class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.references :users, foreign_key: true
      t.references :couriers, foreign_key: true
      t.references :products, foreign_key: true
      t.references :vendors, foreign_key: true
      t.string :description
      t.integer :rating
      t.timestamps
    end
  end
end
