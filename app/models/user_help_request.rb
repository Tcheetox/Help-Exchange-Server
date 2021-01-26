class UserHelpRequest < ApplicationRecord

    belongs_to :user
    belongs_to :help_request

    enum user_type: [:owner, :respondent]
    
end
