
class Api::V1::UsersMailerController < Api::V1::ApplicationController
    include Api::V1::ApplicationHelper
    rescue_from Exception, with: :server_error
    skip_before_action :doorkeeper_authorize!, only: %i[create]

    def create
        return render_error(40001) unless params.has_key?(:subaction)
        verify_client_app

        user = User.find_by(:email => params[:email])
        if user 
            case params[:subaction].downcase
                when 'forgot_password'
                    Thread.new { user.send_reset_password_instructions }
                    return render_response(201, {:message => 'Reset password instructions sent by email'})
                when 'send_confirmation'
                    Thread.new { user.send_confirmation_instructions }
                    return render_response(201, {:message => 'Account confirmation sent by email'})
            end
        else return render_error(40004) end
    end

end
