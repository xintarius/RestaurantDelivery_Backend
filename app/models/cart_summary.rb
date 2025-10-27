# cart summary
class CartSummary < ApplicationRecord
  belongs_to :user
  has_many :cart_product
  has_many :products, through: :cart_product
end