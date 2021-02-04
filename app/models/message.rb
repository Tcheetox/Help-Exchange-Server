class Message < ApplicationRecord

    enum status: [:unread, :read]

    belongs_to :conversation
    belongs_to :user
end
