class MessagesChannel < ApplicationCable::Channel
  include Api::V1::ApplicationHelper
  rescue_from Exception, with: :server_error

  def subscribed
    reject unless current_user && (conversation.respondent_user == current_user || conversation.owner_user == current_user)
    stream_for conversation
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def new_message(data)
    reject unless current_user
    unless !has_content(data) || !is_agent
      message = conversation.messages.create(:user_id => current_user.id, :message => data["content"])
      MessagesChannel.broadcast_to conversation, message.attributes.merge({:user_first_name => current_user.first_name, :user_last_name => current_user.last_name})
    end
  end

  def mark_as_read(data)
    reject unless current_user
    unless !has_content(data) || !is_agent
      message = conversation.messages.find(data["content"])
      if message.user_id != current_user.id && message.status == 'unread' then message.update(:status => Message.statuses[:read]) end
    end
  end

  private

  def conversation
    @conversation ||= Conversation.find(params["conversation"]) 
  end

  def is_agent
    @is_agent ||= conversation.owner_user_id == current_user.id || conversation.respondent_user_id == current_user.id
  end

  def has_content(data)
    data.has_key?("content") && !data["content"].blank?
  end

end
