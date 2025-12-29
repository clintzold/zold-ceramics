class Shipment < ApplicationRecord
  belongs_to :order
  enum :tracking_status, { unknown: 0, failure: 1, returned: 3, delivered: 4, transit: 5, pre_transit: 6 }
end
