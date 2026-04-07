class Subscription < ApplicationRecord
  before_validation { self.email = email.downcase.strip }
  before_validation { self.first_name = first_name.capitalize }
  before_validation { self.last_name = last_name.capitalize }

  validates_presence_of :first_name, :last_name
  validates :email, uniqueness: { case_sensitive: false }
  # Format validation using a Regular Expression (Regex)
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
