class AddFilePathAndDescriptionToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :file_path, :string
    add_column :products, :description, :string
  end
end
