# vendor controller
class Api::VendorsController < ApplicationController
  before_action :authenticate_user!
  def vendors
    per_page = params.fetch(:per_page, 5).to_i
    page = params.fetch(:page, 1).to_i
    vendors = Vendor.limit(per_page).offset((page - 1) * per_page)
                   .select("id, name, file_path, description")
    render json: {
      data: vendors.as_json(only: [:id, :name, :file_path, :description]),
      meta: {
        current_page: page,
        per_page: per_page,
        total_records: Vendor.count,
        total_pages: (Vendor.count / per_page.to_f).ceil
      }
    }
  end
end
