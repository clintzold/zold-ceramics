class Order < ApplicationRecord
  enum :status, { pending: 0, paid: 1, canceled: 2 }
  has_many :order_items, dependent: :destroy
  has_one :shipment, dependent: :destroy
end
