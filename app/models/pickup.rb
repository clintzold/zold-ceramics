class Pickup < ApplicationRecord
  has_and_belongs_to_many :orders

  validates_presence_of :start, :end, :location, :link

end
