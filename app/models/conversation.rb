class Conversation < ApplicationRecord
    has_many :messages
    belongs_to :help_request
    belongs_to :owner_user, class_name: 'User', foreign_key: 'owner_user_id'
    belongs_to :respondent_user, class_name: 'User', foreign_key: 'respondent_user_id'
end
