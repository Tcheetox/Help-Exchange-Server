class ActiveStorage::BaseController < ActionController::Base
    #before_action :doorkeeper_authorize!
    include ActiveStorage::SetCurrent
    protect_from_forgery with: :exception

end