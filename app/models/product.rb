class Product < ApplicationRecord
  validates :title, :description, :price, :stock, presence: true
end
