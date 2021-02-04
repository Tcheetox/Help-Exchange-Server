class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :gov_id
  has_one_attached :tmp_gov_id
  validates :email, format: URI::MailTo::EMAIL_REGEXP

  has_many :user_help_requests
  has_many :help_requests, :through => :user_help_requests
  #has_many :conversations

  # the authenticate method from devise documentation
  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end
  
end
