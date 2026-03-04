# category types controller
class Api::CategoryTypesController < ApplicationController

  def category
    categories = CategoryType.includes(:vendors).select(:id, "category_name as name")
    render json: categories.as_json(include: :vendors)
  end

  def find_category
    vendors = Vendor.where(category_type_id: params[:category_type_id])
    puts vendors
    render json: vendors
  end
end

