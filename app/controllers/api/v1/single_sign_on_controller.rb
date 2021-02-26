class Api::V1::SingleSignOnController < Api::V1::ApplicationController
    include Api::V1::ApplicationHelper
    rescue_from Exception, with: :server_error
    skip_before_action :doorkeeper_authorize!, only: [:create]

    def create
        unless !client_app
            begin
                google_user = GoogleSignIn::Identity.new(sso_params[:token])
                user = User.find_by(:email => google_user.email_address)
                if !user # User don't exists
                    user = User.new(:email => google_user.email_address, :password => SecureRandom.hex(64), :first_name => google_user.given_name, :last_name =>  google_user.family_name, :confirmed_at => DateTime.current)
                    user.skip_confirmation_notification!
                    user.save
                end
                # Return access token
                access_token = Doorkeeper::AccessToken.create(resource_owner_id: user.id, application_id: Doorkeeper::Application.find_by(uid: sso_params[:client_id]).id, refresh_token: generate_refresh_token, expires_in: Doorkeeper.configuration.access_token_expires_in.to_i, scopes: '')
                oauth_response = {:access_token => access_token.token, :token_type => "Bearer", :expires_in => access_token.expires_in, :refresh_token => access_token.refresh_token, :created_at => access_token.created_at.to_time.to_i, :id => user.id, :email => user.email, :completed => user.completed}
            rescue Exception => err
                Rails.logger.info("!!! #{err}")
            end
            # Render
            if !access_token || err then render_error(401, "Client couldn't be authenticated via Google SSO") else render_response(201, oauth_response) end
        end
    end

    private
    def sso_params
        params.delete :single_sign_on unless !params.has_key?(:single_sign_on)
        params.permit(:token, :client_secret, :client_id)
    end

    def generate_refresh_token
        loop do
            token = SecureRandom.hex(32)
            break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
        end
    end 

end