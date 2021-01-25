class UserHelpRequest < ApplicationRecord

    belongs_to :user
    belongs_to :help_request

    enum type: [:owner, :respondent]
    
end
