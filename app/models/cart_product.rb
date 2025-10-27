# cart_product
class CartProduct < ApplicationRecord
  belongs_to :cart_summary
  belongs_to :product
end