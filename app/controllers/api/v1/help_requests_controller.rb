class Api::V1::HelpRequestsController < Api::V1::ApplicationController
  include Api::V1::ApplicationHelper
  rescue_from Exception, with: :server_error
  skip_before_action :doorkeeper_authorize!, only: %i[index]

  # Requests that can be shown on map
  def index
    render_array_response(200, HelpRequest.where(:status => "published"))
  end

  # Requests associated to given user
  def index_user
    render_array_response(200, current_user.help_requests.select("*").joins(:user_help_requests).select("user_help_requests.user_type"))
  end  

  def update
    if all_params_valid(:id, :subaction)
      interactable = false
      case params[:subaction].downcase

        when "cancel" # Owner only
          unless !is_owner
            if help_request.status != "cancelled" && help_request.status != "fulfilled"
              help_request.update(:status => HelpRequest.statuses[:cancelled], :help_count => 0) 
              UserHelpRequest.where(user_id: current_user.id).where.not(user_type: UserHelpRequest.user_types[:owner]).delete_all
            end
            interactable = true
          end
        when "republish" # Owner only
          unless !is_owner
            if help_request.status == "cancelled" || (help_request.status == "pending" && !help_request.pending_at.isblank? && DateTime.current - help_request.pending_at > 1.days)
              help_request.update(:status => HelpRequest.statuses[:published])
            end
            interactable = true
          end
        when "subscribe" # Respondent only 
          unless is_owner
            if help_request.status == "published" && help_request.help_count < 5 && !is_respondent
              current_user.user_help_requests.create(:help_request_id => help_request.id, :user_type => UserHelpRequest.user_types[:respondent])
              if help_request.help_count == 4
                help_request.update(:help_count => help_request.help_count + 1, :status => HelpRequest.statuses[:pending], :pending_at => DateTime.current)
              else help_request.update(:help_count => help_request.help_count + 1) end
            end
            interactable = true
          end 
        when "unsubscribe" # Respondent only  
          unless !is_respondent 
            if help_request.status == "published" || help_request.status == "pending"
              user_help_request.delete
              help_request.update(:help_count => help_request.help_count - 1)
            end
            interactable = true
          end
        when "markasfulfilled" # Both owner and respondents   
          unless !is_owner && !is_respondent
            if help_request.status != "cancelled" && help_request.status != "fulfilled" then help_request.update(:status => HelpRequest.statuses[:fulfilled]) end
            interactable = true
          end     
      end

      # Return appropriate result (augmented by UserHelpRequest attributes if request was interactable)
      if interactable 
        if user_help_request.nil? then render_response(200, help_request.attributes)
        else render_response(200, help_request.attributes.merge(user_help_request.attributes)) end
      else render_error(403, 40301, "You cannot interact with this help request") end
    else render_error(400, 40001, 'Missing and/or invalid parameter(s)') end
  end

  def create
    if (all_params_valid(:help_type, :title, :description, :address, :lat, :lng))
      help_type = help_params["help_type"].downcase == 'material' ? HelpRequest.help_types[:material] : HelpRequest.help_types[:immaterial]
      new_help_request = current_user.help_requests.create(:title => help_params["title"], :description => help_params["description"], :help_type => help_type, 
      :address => help_params["address"], :lat => help_params["lat"], :lng => help_params["lng"], :status => HelpRequest.statuses[:published])
      
      # Update joint-table (:through has_many relationship) to enforce the current_user as the owner of the help_request 
      current_user.user_help_requests.find_by(:help_request_id => new_help_request.id).update(:user_type => UserHelpRequest.user_types[:owner])
      render_response(201, new_help_request.attributes)
    else
      render_error(400, 40001, 'Missing and/or invalid parameter(s)') 
    end
  end

  private

  def help_params
    if (params.has_key?(:help_request))
      params.delete :help_request
    end
    params.permit(:title, :description, :help_type, :address, :lat, :lng)
  end

  def help_request 
    @help_request ||= HelpRequest.find(params[:id])
  end

  def user_help_request
    @user_help_request ||= UserHelpRequest.find_by(:help_request_id => help_request.id, :user_id => current_user.id)
  end

  def is_owner
    !user_help_request.nil? && user_help_request.user_type == "owner"
  end

  def is_respondent
    !user_help_request.nil? && user_help_request.user_type == "respondent"
  end

end
