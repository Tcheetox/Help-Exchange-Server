class ConversationsChannel < ApplicationCable::Channel

  def subscribed
    reject unless current_user
    stream_from "conversations_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
