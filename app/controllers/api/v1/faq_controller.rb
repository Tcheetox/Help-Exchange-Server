class Api::V1::FaqController < Api::V1::ApplicationController
    include Api::V1::ApplicationHelper
    rescue_from Exception, with: :server_error
    skip_before_action :doorkeeper_authorize!, only: %i[index]

    def index
        return render_response(200, Faq.all)
    end

end
