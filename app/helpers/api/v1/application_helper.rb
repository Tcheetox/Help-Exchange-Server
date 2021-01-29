module Api::V1::ApplicationHelper
    # TODO: 300 chars is too long for string => switch desc to text I guess...
    def server_error(exception)
        Rails.logger.info("!!! #{exception}")
        render_error(500, 50000, 'Internal server error')
    end

    def render_error(statusCode, serverCode, description, displayMessage = 'An unexpected error has occured, please try again later.')
        _description = description.kind_of?(Array) ? description.join('. ') : description
        render_json(statusCode, {error: {:server_code => serverCode, :description => _description, :display_message => displayMessage, :timestamp => Time.now.getutc}})
    end

    def render_response(statusCode, body = '', displayMessage = '')
        if statusCode == 204
            head :no_content
        else
            content = displayMessage == '' ? body.merge(:timestamp => Time.now.getutc) : body.merge(:display_message => displayMessage).merge(:timestamp => Time.now.getutc)
            render_json(statusCode, content)
        end
    end

    def render_array_response(statusCode, body)
        if statusCode == 204
            head :no_content
        else render_json(statusCode, body) end
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
