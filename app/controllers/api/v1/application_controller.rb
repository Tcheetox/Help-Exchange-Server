class Api::V1::ApplicationController < ActionController::API
  before_action :doorkeeper_authorize!
  rescue_from Exception, with: :server_error

  private
  # helper method to access the current user from the token
  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id])
  end
end
