class ConversationSerializer < ActiveModel::Serializer
  attributes :id
  has_many :chats
end
