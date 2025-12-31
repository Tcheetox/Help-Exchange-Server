require 'rails_helper'

RSpec.describe Api::V1::HelpRequestsController, type: :request do

    help_requests_route = "/api/v1/help_requests"

    owner_header_auth = { :Authorization => "Bearer #{get_user_access_token("owner_user_seed@test.com")}" }
    owner_help_request_params = {:help_type => 'material', :title => 'title', :description => 'description', :address => "address", :lat => 0, :lng => 0}
    respondent_header_auth = { :Authorization => "Bearer #{get_user_access_token("respondent_user_seed@test.com")}" }

    # POST - Create help request
    it "create help request" do
        post help_requests_route, params: owner_help_request_params, headers: owner_header_auth
        expect(response).to have_http_status(201) 
        expect(JSON.parse(response.body).keys).to contain_exactly("address", "id", "title", "description", "pending_at", "lat", "lng", "created_at" ,"updated_at", "status", "help_type", "users", "help_count", "timestamp")
    end
    it "create help request: missing parameter(s)" do
        post help_requests_route, params: {:title => "title"}, headers: owner_header_auth
        expect(response).to have_http_status(400) 
        expect(JSON.parse(response.body)["error"]["server_code"]).to eql(40001)
    end

    # All user related requests (filtered)
    describe "GET #filter" do
        it "returns success response" do
            get "#{help_requests_route}/filter", params: {}, headers: owner_header_auth
            expect(response).to be_successful 
        end
        it "returns non-empty array" do
            post help_requests_route, params: owner_help_request_params, headers: owner_header_auth
            get "#{help_requests_route}/filter", params: {}, headers: owner_header_auth
            expect(JSON.parse(response.body).length).to be > 0
        end
        it "returns JSON" do
            get "#{help_requests_route}/filter", params: {}, headers: owner_header_auth
            expect(response.content_type).to include("application/json") 
        end
        it "returns private keys" do
            post help_requests_route, params: owner_help_request_params, headers: owner_header_auth
            get "#{help_requests_route}/filter", params: {}, headers: owner_header_auth
            JSON.parse(response.body).each do |req|
                expect(req.keys).to contain_exactly("address", "id", "title", "description", "pending_at", "lat", "lng", "created_at" ,"updated_at", "status", "help_type", "help_count", "users")
            end
        end
    end

    # All published requests
    describe "GET #index" do
        it "returns success response" do
            get help_requests_route
            expect(response).to be_successful # Expects 200
        end
        it "returns non-empty array" do
            post help_requests_route, params: owner_help_request_params, headers: owner_header_auth
            get help_requests_route
            expect(JSON.parse(response.body).length).to be > 0
        end
        it "returns JSON" do
            get help_requests_route
            expect(response.content_type).to include("application/json") 
        end
        it "returns public keys" do
            post help_requests_route, params: owner_help_request_params, headers: owner_header_auth
            get help_requests_route
            JSON.parse(response.body).each do |req|
                expect(req.keys).to contain_exactly("address", "id", "title", "description", "pending_at", "lat", "lng", "created_at" ,"updated_at", "status", "help_type", "help_count", "owner_id")
            end
        end
    end

    # Help request update
    new_respondent_header_auth = owner_header_auth = { :Authorization => "Bearer #{get_user_access_token("profile_user_seed@test.com")}" }
    owner_header_auth = { :Authorization => "Bearer #{get_user_access_token("owner_user_seed@test.com")}" }
    help_request = HelpRequest.find_by(:title => "Test seed title")

    describe "PUT #update" do

        it "prevents wrong subaction" do
            put "#{help_requests_route}/#{help_request.id}/fake", params: {}, headers: new_respondent_header_auth 
            expect(response).to have_http_status(403)
            expect(JSON.parse(response.body)["error"]["server_code"]).to eql(40301)
        end

        # Subscribe
        it "subscribes if not the owner" do
            put "#{help_requests_route}/#{help_request.id}/subscribe", params: {}, headers: new_respondent_header_auth 
            expect(response).to be_successful 
        end
        it "returns keys" do
            put "#{help_requests_route}/#{help_request.id}/subscribe", params: {}, headers: new_respondent_header_auth 
            expect(response).to be_successful 
            expect(JSON.parse(response.body).keys).to contain_exactly("address", "id", "title", "description", "pending_at", "lat", "lng", "created_at" ,"updated_at", "status", "help_type", "users", "help_count", "timestamp")
        end
        it "prevents subscription from current owner" do
            put "#{help_requests_route}/#{help_request.id}/subscribe", params: {}, headers: owner_header_auth 
            expect(response).to have_http_status(403)
            expect(JSON.parse(response.body)["error"]["server_code"]).to eql(40301)
        end

        # Unsubscribe
        it "unsubscribes if respondent" do
            put "#{help_requests_route}/#{help_request.id}/unsubscribe", params: {}, headers: respondent_header_auth 
            expect(response).to be_successful 
        end
        it "prevent unsubscribe from non-respondent" do
            put "#{help_requests_route}/#{help_request.id}/unsubscribe", params: {}, headers: new_respondent_header_auth 
            expect(response).to have_http_status(403)
            expect(JSON.parse(response.body)["error"]["server_code"]).to eql(40301) 
        end

        # Mark as fulfilled
        it "mark as fulfilled if respondent" do
            put "#{help_requests_route}/#{help_request.id}/markasfulfilled", params: {}, headers: respondent_header_auth 
            expect(response).to be_successful
            expect(JSON.parse(response.body)["status"]).to eql("fulfilled") 
        end
        it "mark as fulfilled if owner" do
            put "#{help_requests_route}/#{help_request.id}/markasfulfilled", params: {}, headers: owner_header_auth 
            expect(response).to be_successful
        end
        it "prevents mark as fulfilled from outsider" do
            put "#{help_requests_route}/#{help_request.id}/markasfulfilled", params: {}, headers: new_respondent_header_auth 
            expect(response).to have_http_status(403)
            expect(JSON.parse(response.body)["error"]["server_code"]).to eql(40301) 
        end

        # Cancel
        it "cancels if owner" do
            put "#{help_requests_route}/#{help_request.id}/cancel", params: {}, headers: owner_header_auth 
            expect(response).to be_successful
            expect(JSON.parse(response.body)["status"]).to eql("cancelled") 
        end
        it "prevents cancellation from respondent" do
            put "#{help_requests_route}/#{help_request.id}/cancel", params: {}, headers: respondent_header_auth 
            expect(response).to have_http_status(403)
            expect(JSON.parse(response.body)["error"]["server_code"]).to eql(40301) 
        end
        it "prevents cancellation from outside" do
            put "#{help_requests_route}/#{help_request.id}/cancel", params: {}, headers: new_respondent_header_auth 
            expect(response).to have_http_status(403)
            expect(JSON.parse(response.body)["error"]["server_code"]).to eql(40301) 
        end

        # Republish
        it "republish if owner" do
            put "#{help_requests_route}/#{help_request.id}/republish", params: {}, headers: owner_header_auth 
            expect(response).to be_successful
        end
        it "prevents republish from respondent" do
            put "#{help_requests_route}/#{help_request.id}/republish", params: {}, headers: respondent_header_auth 
            expect(response).to have_http_status(403)
            expect(JSON.parse(response.body)["error"]["server_code"]).to eql(40301) 
        end
        it "prevents republish from outside" do
            put "#{help_requests_route}/#{help_request.id}/republish", params: {}, headers: new_respondent_header_auth 
            expect(response).to have_http_status(403)
            expect(JSON.parse(response.body)["error"]["server_code"]).to eql(40301) 
        end

    end


end
