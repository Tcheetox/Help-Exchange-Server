require 'rails_helper'

RSpec.describe 'Routes', :type => :routing do

    api_version = "api/v1"
    routes_prefix = "krenier/fishforhelp/#{api_version}"

    # FAQ
    it "#{routes_prefix}/faq to #{api_version}/faq#index" do
        expect(get: "#{routes_prefix}/faq").to route_to(controller: "#{api_version}/faq", action: "index")
    end

    # Help requests
    it "#{routes_prefix}/help_requests to #{api_version}/help_requests#index" do
        expect(get: "#{routes_prefix}/help_requests").to route_to(controller: "#{api_version}/help_requests", action: "index")
    end
    it "#{routes_prefix}/help_requests to #{api_version}/help_requests#create" do
        expect(post: "#{routes_prefix}/help_requests").to route_to(controller: "#{api_version}/help_requests", action: "create")
    end
    it "#{routes_prefix}/help_requests/filter to #{api_version}/help_requests#filter" do
        expect(get: "#{routes_prefix}/help_requests/filter").to route_to(controller: "#{api_version}/help_requests", action: "filter")
    end
    it "#{routes_prefix}/help_requests/:id/:subaction to #{api_version}/help_requests#update" do
        expect(put: "#{routes_prefix}/help_requests/:id/:subaction").to route_to(controller: "#{api_version}/help_requests", action: "update", id: ":id", subaction: ":subaction")
    end

    # Conversations
    it "#{routes_prefix}/conversations to #{api_version}/conversations#index" do
        expect(get: "#{routes_prefix}/conversations").to route_to(controller: "#{api_version}/conversations", action: "index")
    end
    it "#{routes_prefix}/conversations to #{api_version}/conversations#create" do
        expect(post: "#{routes_prefix}/conversations").to route_to(controller: "#{api_version}/conversations", action: "create")
    end
    it "#{routes_prefix}/conversations/:id to #{api_version}/conversations#show" do
        expect(get: "#{routes_prefix}/conversations/:id").to route_to(controller: "#{api_version}/conversations", action: "show", id: ":id")
    end

    # OAuth & SSO
    it "#{routes_prefix}/oauth/sso to #{api_version}/single_sign_on#create" do
        expect(post: "#{routes_prefix}/oauth/sso").to route_to(controller: "#{api_version}/single_sign_on", action: "create")
    end
    it "#{routes_prefix}/oauth/token to doorkeeper/token#create" do
        expect(post: "#{routes_prefix}/oauth/token").to route_to(controller: "doorkeeper/tokens", action: "create")
    end
    it "#{routes_prefix}/oauth/revoke to doorkeeper/token#revoke" do
        expect(post: "#{routes_prefix}/oauth/revoke").to route_to(controller: "doorkeeper/tokens", action: "revoke")
    end
    it "#{routes_prefix}/oauth/introspect to doorkeeper/token#introspect" do
        expect(post: "#{routes_prefix}/oauth/introspect").to route_to(controller: "doorkeeper/tokens", action: "introspect")
    end

    # Users
    it "#{routes_prefix}/users to #{api_version}/users#create" do
        expect(post: "#{routes_prefix}/users").to route_to(controller: "#{api_version}/users", action: "create")
    end
    it "#{routes_prefix}/users to #{api_version}/users#show" do
        expect(get: "#{routes_prefix}/users").to route_to(controller: "#{api_version}/users", action: "show")
    end
    it "#{routes_prefix}/users to #{api_version}/users#destroy" do
        expect(delete: "#{routes_prefix}/users").to route_to(controller: "#{api_version}/users", action: "destroy")
    end
    it "#{routes_prefix}/users to #{api_version}/users#update" do
        expect(put: "#{routes_prefix}/users").to route_to(controller: "#{api_version}/users", action: "update")
    end
    it "#{routes_prefix}/users/:subaction to #{api_version}/users#update_without_password" do
        expect(put: "#{routes_prefix}/users/:subaction").to route_to(controller: "#{api_version}/users", action: "update_without_password", subaction: ":subaction")
    end
    it "#{routes_prefix}/users/storage to #{api_version}/users_storage#create" do
        expect(post: "#{routes_prefix}/users/storage").to route_to(controller: "#{api_version}/users_storage", action: "create")
    end
    it "#{routes_prefix}/users/mailer/:subaction to #{api_version}/users_mailer#create" do
        expect(post: "#{routes_prefix}/users/mailer/:subaction").to route_to(controller: "#{api_version}/users_mailer", action: "create", subaction: ":subaction")
    end

end