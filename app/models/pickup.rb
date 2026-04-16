class Pickup < ApplicationRecord
  has_and_belongs_to_many :orders

  validates_presence_of :start, :end, :location, :link

  before_create :add_orders
  after_create_commit :send_notification_email

  private

  def add_orders
    self.orders << Order.where(local: true)
  end

  def send_notification_email
    self.orders.each do |order|
      NotifierMailer.with(pickup: self, order: order).pickup_email.deliver_now
    end
  end

end
