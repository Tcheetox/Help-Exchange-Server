class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :confirmable, :validatable

  has_one_attached :gov_id
  has_one_attached :tmp_gov_id
  validates :email, format: URI::MailTo::EMAIL_REGEXP

  has_many :user_help_requests
  has_many :help_requests, :through => :user_help_requests

  # The authenticate method from devise documentation
  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user && user.confirmed? && user.valid_password?(password) && !user.deleted_at? ? user : nil
  end

end
