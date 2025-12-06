class User < ApplicationRecord
  after_create_commit :initialize_cart
  has_one :cart
  has_many :reservations
  has_many :cart_items, through: :cart
  has_many :orders
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  private

  # Add a cart object for user to populate
  def initialize_cart
    self.create_cart!
  end
end
