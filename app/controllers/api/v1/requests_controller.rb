
# module Api
#     class RequestsController < API::V1::ApplicationController
#         def index
#             @requests = Request.all
#             render json: {requests: @requests}
#         end
#     end
# end


class Api::V1::RequestsController < Api::V1::ApplicationController
    def index
        @requests = Request.all
        render json: {requests: @requests}
    end
end
