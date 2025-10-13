# vendor controller
class Api::VendorsController < ApplicationController

  def vendors
    vendor = Vendor.select("id, name, file_path, description")
    render json: vendor
  end
end
