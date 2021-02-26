module RequestMacros

    def get_user(email)
      return User.find_by(:email => email)
    end

    def get_user_access_token(email)
      user = User.find_by(:email => email)
      access_token = Doorkeeper::AccessToken.create(resource_owner_id: user.id, application_id: Doorkeeper::Application.find_by(uid: ENV['HELPEXCHANGE_APP_ID']).id, expires_in: Doorkeeper.configuration.access_token_expires_in.to_i, scopes: '')
      return access_token.token
    end

    def add_app_params(params)
      params.merge({:client_id => ENV['HELPEXCHANGE_APP_ID'], :client_secret => ENV['HELPEXCHANGE_APP_SECRET']})
    end
  
  end
    