# category types controller
class Api::CategoryTypesController < ApplicationController

  def category
    categories = CategoryType.all
    formatted_categories = categories.map do |cat|
      {
        id: cat.id,
        category_name: cat.category_name
      }
    end
    render json: formatted_categories, status: :ok
  end

  def find_category
    vendors = Vendor.where(category_type_id: params[:category_type_id])
    puts vendors
    render json: vendors
  end
end

