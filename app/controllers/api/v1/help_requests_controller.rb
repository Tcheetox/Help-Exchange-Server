class Api::V1::HelpRequestsController < Api::V1::ApplicationController
  include Api::V1::ApplicationHelper
  rescue_from Exception, with: :server_error

  def create

    if (all_params_valid(:help_type, :title, :description, :address, :lat, :lng))
      help_type = help_params["help_type"].downcase == 'material' ? HelpRequest.help_types[:material] : HelpRequest.help_types[:immaterial]
      help_request = current_user.help_requests.create(:title => help_params["title"], :description => help_params["description"], :help_type => help_type, 
      :address => help_params["address"], :lat => help_params["lat"], :lng => help_params["lng"], :status => HelpRequest.statuses[:published])
      # Update joint-table (:through has_many relationship) to enforce the current_user as the owner of the help_request 
      current_user.user_help_requests.find_by(:help_request_id => help_request.id).update(:user_type => UserHelpRequest.user_types[:owner])
      render_response(201, help_request.attributes)
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

end
