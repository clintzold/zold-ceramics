class Subscription < ApplicationRecord
  before_validation { self.email = email.to_s.downcase.strip }

  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
