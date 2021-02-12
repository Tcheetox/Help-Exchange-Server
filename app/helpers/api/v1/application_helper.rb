module Api::V1::ApplicationHelper

    def verify_client_app
        return render_error(40001) unless params.has_key?(:client_id) && params.has_key?(:client_secret)
        return render_error(40000) unless (client_app ||= Doorkeeper::Application.find_by(uid: params[:client_id])) && client_app.secret == params[:client_secret]
    end

    def server_error(exception)
        Rails.logger.info("!!! #{exception}")
        render_error(50000)
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
            when 50001
                description = 'Impossible to destroy ressource'
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

    private 

    def render_json(statusCode, body)
        render :json => body, :status => statusCode,
            :content_type => 'application/json',
            :layout => false
    end

end
