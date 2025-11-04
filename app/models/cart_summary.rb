# cart summary
class CartSummary < ApplicationRecord
  belongs_to :user
  has_many :cart_products
  has_many :products, through: :cart_products

  accepts_nested_attributes_for :cart_products
end
