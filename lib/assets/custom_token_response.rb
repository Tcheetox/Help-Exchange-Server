module CustomTokenResponse
    def body
        if !@token.scopes.first.blank?
            additional_data = {:email => User.find(@token.resource_owner_id).email, :cookie => @token.scopes.first}
            @token.scopes = ''
        else
            additional_data = {:email => User.find(@token.resource_owner_id).email}
        end
        # call original `#body` method and merge its result with the additional data hash
        super.merge(additional_data)
    end
end