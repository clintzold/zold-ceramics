class Order < ApplicationRecord
  enum :status, { pending: 0, paid: 1, canceled: 2 }
  belongs_to :user
  has_many :order_items, dependent: :destroy
end
