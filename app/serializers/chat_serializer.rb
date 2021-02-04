class ChatSerializer < ActiveModel::Serializer
  attributes :id, conversation_id, :string, :created_at
end
