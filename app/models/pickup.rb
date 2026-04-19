class Pickup < ApplicationRecord
  has_and_belongs_to_many :orders

  validates_presence_of :start, :end, :location, :link

  before_create :add_orders
  after_create_commit :send_new_email
  after_update :send_rescheduled_email
  before_destroy :send_canceled_email

  private

  def add_orders
    self.orders << Order.where(local: true, status: "paid")
  end

  def send_new_email
    self.orders.each do |order|
      NotifierMailer.with(pickup: self, order: order).new_pickup_email.deliver_later
    end
  end

  def send_rescheduled_email
    self.orders.each do |order|
      NotifierMailer.with(pickup: self, order: order).pickup_rescheduled_email.deliver_later
    end
  end

  def send_canceled_email
    self.orders.each do |order|
      date = self.date
      NotifierMailer.with(date: date, order: order).pickup_canceled_email.deliver_later
    end
  end
end
