module ApplicationCable
  class Connection < ActionCable::Connection::Base
    # https://github.com/doorkeeper-gem/doorkeeper/wiki/Doorkeeper-and-ActionCable
    identified_by :current_user

    def connect
      self.current_user = authenticate!
    end

    protected
    def authenticate! 
      user = access_token && access_token&.acceptable?(@_doorkeeper_scopes) ? User.find_by(id: access_token.resource_owner_id) : nil
      user || reject_unauthorized_connection
    end

    def access_token
      @access_token ||= Doorkeeper::AccessToken.by_token(request.params[:token])
    end

  end
end
