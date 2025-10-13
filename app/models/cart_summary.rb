# cart summary
class CartSummary < ApplicationRecord
  belongs_to :user
  has_many :cart_products
  has_many :product, through: :cart_products
end