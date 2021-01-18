module CustomTokenResponse
    def body
        user = User.find(@token.resource_owner_id)
        if !@token.scopes.first.blank?
            additional_data = {:email => user.email, :completed => user.completed, :cookie => @token.scopes.first}
            @token.scopes = ''
        else
            additional_data = {:email => user.email, :completed => user.completed}
        end
        # call original `#body` method and merge its result with the additional data hash
        super.merge(additional_data)
    end
end