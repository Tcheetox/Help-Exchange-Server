class Api::V1::UsersController < Api::V1::ApplicationController
    include Api::V1::ApplicationHelper
    rescue_from Exception, with: :server_error
    skip_before_action :doorkeeper_authorize!, only: [:create, :update_without_password]

    # TODO: change destroy method
    # TODO: store blob url in profile as string!!! efficiency 

    def show
      render_response(200, user_profile)
    end

    def update_without_password
      verify_client_app
      case user_params[:subaction].downcase

        when 'forgotten_password'
          return render_error(40001) unless user_params.has_key?(:password) && user_params.has_key?(:reset_password_token) && (user ||= User.find_by(:reset_password_token => Devise.token_generator.digest(User,:reset_password_token, user_params[:reset_password_token])))
          return render_error(40300) unless Devise.password_length.include?(user_params[:password].length)  
          user.update(:password => user_params[:password])
          return render_response(204)
        
        when 'confirm_account'
          return render_error(40001) unless (user ||= User.find_by(:confirmation_token => user_params[:confirmation_token]))
          user.update(:confirmed_at => DateTime.current)
          return render_response(204)
     
      end
      return render_error(40001) 
    end

    def update
      # Attempt to update user's current password
      if (user_params.has_key?(:password) && user_params.has_key?(:current_password))
        if !Devise.password_length.include?(user_params[:password].length) 
          return render_error(40300)     
        elsif !current_user.valid_password?(user_params[:current_password])
          return render_error(40302) 
        else
          current_user.update(:password => user_params[:password])
          return render_response(204)
        end
      
      # Update any other information from profile
      else 
        handle_gov_id(params[:gov_id]) # Confirm or discard gov_id change
        current_user.update(:first_name => user_params[:first_name], :last_name => user_params[:last_name], :phone => user_params[:phone], :post_code => user_params[:post_code], :address => user_params[:address], :country => user_params[:country], :lng => user_params[:lng], :lat => user_params[:lat])
        if (!user_params[:first_name].blank? && !user_params[:last_name].blank? && !user_params[:phone].blank? && !user_params[:address].blank? && !user_params[:post_code].blank? && !user_params[:country].blank? && !current_user.gov_id.blank?)
          current_user.update(:completed => true)
        else current_user.update(:completed => false) end
        return render_response(200, user_profile)
      end
    end

    def destroy
      if current_user.destroy
        render_response(204)
      else
        render_error(50001, "Impossible to destroy user #{current_user.email}")
      end
    end

    def create
      verify_client_app
      user = User.new(email: user_params[:email], password: user_params[:password])
      user.skip_confirmation_notification!
      if user.save
        Thread.new { user.send_confirmation_instructions }
        render_response(201, {:message => 'User email must be confirmed to allow authentication'})
      else
        # Email already in use
        render_error(42201, user.errors.full_messages)
      end
    end

    private

    def handle_gov_id(url)
      if url.blank? # Delete any existing storage
        current_user.gov_id.purge_later unless current_user.gov_id.blank?
        current_user.tmp_gov_id.purge_later unless current_user.tmp_gov_id.blank?
      elsif !current_user.tmp_gov_id.blank? && url_for(current_user.tmp_gov_id) == url # Update current gov_id
        current_user.gov_id.attach(current_user.tmp_gov_id.blob)
        current_user.tmp_gov_id.detach()
      end
    end

    def user_params
      params.delete :user unless !params.has_key?(:user)
      params.permit(:email, :password, :subaction, :confirmation_token, :reset_password_token, :current_password, :first_name, :last_name, :phone, :post_code, :address, :country, :client_id, :client_secret, :gov_id, :lat, :lng)
    end

    def generate_refresh_token
      loop do
        # Generate a random token string and return it, unless there is already another token with the same string
        token = SecureRandom.hex(32)
        break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
      end
    end 
  
    def user_profile
      gov_id_url = current_user.gov_id.blank? ? nil : url_for(current_user.gov_id)
      { :email => current_user.email, :created_at => current_user.created_at, :first_name => current_user.first_name, :last_name => current_user.last_name, :phone => current_user.phone, 
      :address => current_user.address, :post_code => current_user.post_code, :country => current_user.country, :lat => current_user.lat, :lng => current_user.lng,
      :gov_id => gov_id_url,:completed => current_user.completed }
    end

end
