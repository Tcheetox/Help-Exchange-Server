module CustomTokenResponse
    def body
        user = User.find(@token.resource_owner_id)
        puts "USER FOUND"
        puts user
        # call original `#body` method and merge its result with the additional data hash
        super.merge({:id => user.id, :email => user.email, :completed => user.completed})
    end
end