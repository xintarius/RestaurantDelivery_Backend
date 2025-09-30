# order model
class Order < ApplicationRecord
  belongs_to :user
  belongs_to :vendor
  belongs_to :product
end
