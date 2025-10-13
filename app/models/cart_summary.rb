# cart summary
class CartSummary < ApplicationRecord
  belongs_to :user
  has_many :cart_product
  has_many :product, through: :cart_product
end