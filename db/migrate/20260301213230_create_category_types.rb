class CreateCategoryTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :category_types do |t|
      t.string :category_name
      t.string :category_code
      t.string :description
      t.timestamps
    end
  end
end
