class Api::V1::UsersController < Api::V1::ApplicationController
    include Api::V1::ApplicationHelper
    rescue_from Exception, with: :server_error
    skip_before_action :doorkeeper_authorize!, only: %i[create]

    def show
      render_response(200, user_profile)
    end

    def update
      # Attempt to update user's current password
      if (user_params.has_key?(:password) && user_params.has_key?(:current_password))
        if !Devise.password_length.include?(user_params[:password].length) 
          render_error(403, 40301, "New password doesn't match security policies")     
        elsif !current_user.valid_password?(user_params[:current_password])
          render_error(403, 40302, "Current password is invalid") 
        else
          current_user.update(:password => user_params[:password])
          render_response(204)
        end
      else # Update user profile
        # TODO: handle verify with email, etc.
        current_user.update(:first_name => user_params[:first_name], :last_name => user_params[:last_name], :phone => user_params[:phone], :gender => user_params[:gender], :address => user_params[:address], :country => user_params[:country])
        if (!user_params[:first_name].blank? && !user_params[:last_name].blank? && !user_params[:phone].blank? && !user_params[:address].blank? && !user_params[:country].blank?)
          current_user.update(:completed => true)
        else
          current_user.update(:completed => false)
        end
        render_response(200, user_profile)
      end
    end

    def destroy
      if current_user.destroy
        render_response(204)
      else
        render_error(500, 50001, "Impossible to destroy user #{current_user.email}")
      end
    end

    def create
      user = User.new(email: user_params[:email], password: user_params[:password])
      client_app = Doorkeeper::Application.find_by(uid: params[:client_id])
      return render_error(403, 40300, 'Invalid client ID') unless client_app

      if user.save
        # Create access token for the user, so the user won't need to login again after registration
        access_token = Doorkeeper::AccessToken.create(
          resource_owner_id: user.id,
          application_id: client_app.id,
          refresh_token: generate_refresh_token,
          expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
          scopes: ''
        )
        
        # Return json containing access token and refresh token so that user won't need to call login API right after registration
        render(json: {
          user: {
            access_token: access_token.token,
            token_type: 'bearer',
            expires_in: access_token.expires_in,
            refresh_token: access_token.refresh_token,
            created_at: access_token.created_at.to_time.to_i
          }
        })
      else
        # Email already in use
        render_error(422, 42201, user.errors.full_messages, '')
      end
    end

    private
    def user_params
      params.permit(:email, :password, :current_password, :first_name, :last_name, :phone, :gender, :address, :country, :client_id, :client_secret) # TODO: thing about this?
    end

    def generate_refresh_token
      loop do
        # Generate a random token string and return it, unless there is already another token with the same string
        token = SecureRandom.hex(32)
        break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
      end
    end 
  
    def user_profile
      { :email => current_user.email, :created_at => current_user.created_at, :first_name => current_user.first_name, :last_name => current_user.last_name, :phone => current_user.phone, :gender => current_user.gender, :address => current_user.address, :country => current_user.country, :completed => current_user.completed }
    end

    protected
    def server_error(exception)
      render_error(500, 50000, "Internal server error")
    end
 
end
