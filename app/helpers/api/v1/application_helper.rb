module Api::V1::ApplicationHelper

    def render_error(statusCode, serverCode, description, displayMessage = 'An unexpected error has occured, please try again later.')
        _description = description.kind_of?(Array) ? description.join('. ') : description
        render :json => {error: {:server_code => serverCode, :description => _description, :display_message => displayMessage, :timestamp => Time.now.getutc}}, :status => statusCode,
            :content_type => 'application/json',
            :layout => false
    end

    def is_numeric(obj)
        obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end

end
