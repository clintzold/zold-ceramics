class Pickup
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :start, :datetime
  attribute :end, :datetime
  attribute :location, :string
  attribute :link, :string

  validates_presence_of :start, :end, :location, :link

  def send_emails
    orders = Order.where(local: true)
    orders.each do |order|
      NotifierMailer.with(pickup: self, order: order).pickup_email.deliver_later
    end
  end

end
