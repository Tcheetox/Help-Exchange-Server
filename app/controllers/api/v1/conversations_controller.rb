class Api::V1::ConversationsController < Api::V1::ApplicationController
    include Api::V1::ApplicationHelper
    rescue_from Exception, with: :server_error
    skip_before_action :doorkeeper_authorize!, only: %i[index]

    def index
      conversations = Conversation.where("owner_user_id = #{current_user.id} OR respondent_user_id = #{current_user.id}").joins("INNER JOIN users ON (users.id = conversations.owner_user_id OR users.id = conversations.respondent_user_id) AND users.id != #{current_user.id}").joins(:help_request).joins("LEFT OUTER JOIN messages ON conversations.id = messages.conversation_id")
      .select("conversations.id, conversations.created_at, conversations.updated_at, conversations.help_request_id, help_requests.title as help_request_title, users.id as target_user_id, users.first_name as target_user_first_name, users.last_name as target_user_last_name, COUNT(messages.id) AS total_messages, SUM(CASE WHEN messages.status = 0 AND messages.user_id != #{current_user.id} THEN 1 ELSE 0 END) AS unread_messages").group(:id)
      render_response(200, conversations)
    end

    def show
      conversation = Conversation.find(params[:id]) 
      if conversation.owner_user_id == current_user.id || conversation.respondent_user_id == current_user.id
        conversation.messages.where.not(:user_id => current_user.id).where(:status => Message.statuses[:unread]).update_all(:status => Message.statuses[:read])
        render_response(200, conversation.messages.joins(:user).select("messages.*, users.first_name as user_first_name, users.last_name as user_last_name").order(updated_at: :asc))
      else
        render_error(400, 40001, 'Missing and/or invalid parameter(s)')
      end
    end

    def create
        # Safety checks: agents are not the same, cover both roles and belongs to the help request. Prevent duplicated conversation. 
        if all_params_valid(:help_request_id, :target_user_id) && conversation_params[:target_user_id] != current_user.id && agents_bound_to_request
          unless is_owner ? Conversation.where(:help_request_id => help_request.id, :owner_user_id => current_user.id, :respondent_user_id => conversation_params[:target_user_id]).exists? : Conversation.where(:help_request_id => help_request.id, :owner_user_id => conversation_params[:target_user_id], :respondent_user_id => current_user.id).exists?
            target_user = User.find(conversation_params[:target_user_id])
            conversation = is_owner ? help_request.conversations.create(owner_user_id: current_user.id, respondent_user_id: conversation_params[:target_user_id]) : help_request.conversations.create(owner_user_id: conversation_params[:target_user_id], respondent_user_id: current_user.id)
            
            augmented_conversation = conversation.attributes.merge({:help_request_title => help_request.title, :target_user_id => target_user.id, 
              :target_user_first_name => target_user.first_name, :target_user_last_name => target_user.last_name, :total_messages => 0, :unread_messages => 0}).except!("owner_user_id", "respondent_user_id")
            
            ActionCable.server.broadcast 'conversations_channel', augmented_conversation
            render_response(201, augmented_conversation)
            return
          end
        end
        render_error(400, 40001, 'Missing and/or invalid parameter(s)')
    end

    private

    def conversation_params
      if (params.has_key?(:conversation))
        params.delete :conversation
      end
      params.permit(:help_request_id, :target_user_id)
    end

    def agents_bound_to_request
      is_owner ? !associated_user_help_requests.find_by(:user_id => conversation_params[:target_user_id], :user_type => UserHelpRequest.user_types[:respondent]).blank? 
        : !associated_user_help_requests.find_by(:user_id => conversation_params[:target_user_id], :user_type => UserHelpRequest.user_types[:owner]).blank?
    end

    def help_request
      @help_request ||= HelpRequest.find(conversation_params[:help_request_id])
    end

    def associated_user_help_requests 
      @user_help_requests ||= help_request.user_help_requests
    end

    def is_owner
      @is_owner ||= !associated_user_help_requests.find_by(:user_id => current_user.id, :user_type => UserHelpRequest.user_types[:owner]).blank?
    end
  
    def is_respondent
      @is_respondent ||= !associated_user_help_requests.find_by(:user_id => current_user.id, :user_type => UserHelpRequest.user_types[:respondent]).blank?
    end

end
