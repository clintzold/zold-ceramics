class Pickup
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :start, :datetime
  attribute :end, :datetime
  attribute :location, :string
  attribute :link, :string

  validates_presence_of :start, :end, :location, :link

  def send_email
  end

end
