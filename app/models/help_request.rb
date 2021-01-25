class HelpRequest < ApplicationRecord

    has_many :user_help_requests
    has_many :users, :through => :user_help_requests

    enum state: [:published, :pending, :cancelled, :fulfilled]
    enum type: [:material, :immaterial]

end
