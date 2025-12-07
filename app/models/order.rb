class Order < ApplicationRecord
  enum :status, { pending: 0, paid: 2, canceled: 3 }
  belongs_to :user
  has_many :order_items
end
