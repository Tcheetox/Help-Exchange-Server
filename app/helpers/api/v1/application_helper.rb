module Api::V1::ApplicationHelper

    def client_app
        if !params.has_key?(:client_id) || !params.has_key?(:client_secret)
            render_error(40001)
            return false
        elsif !(client_app ||= Doorkeeper::Application.find_by(uid: params[:client_id])) || client_app.secret != params[:client_secret]
            puts "NOT THE PROPER CLIENT APP"
            render_error(40000) 
            return false
        end
        return true
    end

    def server_error(exception)
        Rails.logger.info("!!! #{exception}")
        if ENV['HELPEXCHANGE_DEBUG'] == 'true'
            render_error(50000, exception)
        else
            render_error(50000, "#{exception.backtrace.first}: #{exception.message} (#{exception.class})", exception.backtrace.drop(1).map{|s| "\t#{s}"})
        end
    end

    def render_error(serverCode, additionalDescription = '')

        case serverCode
            when 40000
                description = 'Invalid client information'
            when 40001
                description = 'Missing and/or invalid parameter(s)'
            when 40002
                description = 'Invalid input file'
            when 40003
                description = 'Unsupported file type'
            when 40004
                description = 'Email not found'
            when 40300
                description = "New password doesn't match security policies"
            when 40301
                description = 'You cannot interact with this ressource'
            when 40302
                description = 'Current password is invalid'
            when 42201
                description = 'Impossible to save ressource'
            when 50000
                description = 'Internal server error'
        end

        _additionalDescription = additionalDescription.kind_of?(Array) ? additionalDescription.join('. ') : additionalDescription
        if _additionalDescription.blank?
            return render_json(serverCode.to_s.first(3).to_i, {error: {:server_code => serverCode, :description => description, :timestamp => Time.now.getutc}})
        else 
            return render_json(serverCode.to_s.first(3).to_i, {error: {:server_code => serverCode, :description => description, :additional_description => _additionalDescription, :timestamp => Time.now.getutc}})
        end
    end

    def render_response(statusCode, body = '')
        if statusCode == 204
            head :no_content
        elsif !body.nil? && (body.kind_of?(ActiveRecord::Relation) || body.kind_of?(Array))
            render_json(statusCode, body)
        else
            render_json(statusCode, body.merge(:timestamp => Time.now.getutc))
        end
    end

    def is_numeric(obj)
        obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end

    def all_params_valid(*params_list)
        params_list.each { |p| 
                if !params.has_key?(p) || params[p].blank?
                    return false
                end
            }
        return true
    end

    def send_mail(user, type)

        # Google auth through service account with domain-wide delegation
        authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
        json_key_io: File.open('config/google_gmail_key.json'),
        scope: 'https://mail.google.com/')
        gmail = Google::Apis::GmailV1::GmailService.new
        gmail.authorization = authorizer.dup
        gmail.authorization.sub = ENV['HELPEXCHANGE_MAILER_USERNAME']

        # Generate token and associate it to provided user
        if type == :reset_password 
            raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
            user.reset_password_token = hashed
            user.reset_password_sent_at = Time.now.utc
            user.save
        else
            raw, hashed = Devise.token_generator.generate(User, :confirmation_token)
            user.confirmation_token = hashed
            user.confirmation_sent_at = Time.now.utc
            user.save
        end

        # Build mail
        mail = Mail.new
        mail.subject = type == :reset_password ? "Fish For Help: reset your password" : "Fish For Help: confirm your account"
        mail.from = ENV['HELPEXCHANGE_MAILER_SENDER']
        mail.to = user.email
        mail.content_type = "text/html"
        mail.body = build_mail_body(user, type, type == :reset_password ? user.reset_password_token : user.confirmation_token)
        message_object = Google::Apis::GmailV1::Message.new(raw:mail.to_s)
        gmail.send_user_message('me', message_object)

    end

    private 

    def render_json(statusCode, body)
        render :json => body, :status => statusCode,
            :content_type => 'application/json',
            :layout => false
    end

    def build_mail_body(user, type, token)
        if type == :reset_password
            return "Hello #{user.first_name.blank? ? user.email : user.first_name},
                <br/> <br/>
                Someone has requested to change your password. You can do this through the below link: <br/>
                #{ENV['HELPEXCHANGE_FRONTEND_ROOT_URL']}/users/troubleshoot/reset/#{token}
                <br/> <br/>
                Note that your password won't change until you access this link and create a new one. <br/>
                If you are not the author of this request, please ignore this email.
                <br/> <br/>
                Kind regards, <br/>
                The FishForHelp team"
        elsif type == :send_confirmation
            return "Welcome #{user.email},
                <br/> <br/>
                You can confirm your account through the below link:<br/>
                #{ENV['HELPEXCHANGE_FRONTEND_ROOT_URL']}/users/login/#{token}
                <br/> <br/>
                We are excited to have you on board!
                <br/> <br/>
                Kind regards, <br/>
                The FishForHelp team"
        end
    end

end
