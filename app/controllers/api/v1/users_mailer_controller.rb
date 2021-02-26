
class Api::V1::UsersMailerController < Api::V1::ApplicationController
    include Api::V1::ApplicationHelper
    rescue_from Exception, with: :server_error
    skip_before_action :doorkeeper_authorize!, only: %i[create]

    def create
        if params.has_key?(:subaction) && (params[:subaction].downcase == 'forgot_password' || params[:subaction].downcase == 'send_confirmation')
            unless !client_app
                user = User.find_by(:email => params[:email])
                if user 
                    case params[:subaction].downcase
                        when 'forgot_password'
                            if user.email.include? "@test.com" then
                                user.send_reset_password_instructions
                            else
                                Thread.new { user.send_reset_password_instructions }
                            end
                            return render_response(201, {:message => 'Reset password instructions sent by email'})
                        when 'send_confirmation'
                            if user.email.include? "@test.com" then
                                user.send_confirmation_instructions
                            else
                                Thread.new { user.send_confirmation_instructions }
                            end
                            return render_response(201, {:message => 'Account confirmation sent by email'})
                    end
                else return render_error(40004) end
            end
        else return render_error(40001) end
    end

end
