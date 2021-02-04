class HelpRequest < ApplicationRecord

    has_many :user_help_requests
    has_many :users, :through => :user_help_requests
    has_many :conversations

    enum status: [:published, :pending, :cancelled, :fulfilled]
    enum help_type: [:material, :immaterial]

end
