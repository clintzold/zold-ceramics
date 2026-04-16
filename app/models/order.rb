class Order < ApplicationRecord
  has_secure_token :token
  enum :status, { pending: 0, paid: 1, canceled: 2, delivered: 4 }
  has_many :order_items, dependent: :destroy
  has_one :shipment, dependent: :destroy
  has_and_belongs_to_many :pickups
end
