class Order < ApplicationRecord
  has_secure_token :token
  enum :status, { pending: 0, paid: 1, delivered: 2 }
  has_many :order_items, dependent: :destroy
  has_and_belongs_to_many :pickups
end
