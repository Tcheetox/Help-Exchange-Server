require 'rails_helper'

RSpec.describe Api::V1::ConversationsController, type: :request do

conversations_route = "/api/v1/conversations"

    outsider_header_auth = { :Authorization => "Bearer #{get_user_access_token("unrelated_user_seed@test.com")}" }
    existing_respondent = User.find_by(:email => "respondent_user_seed@test.com")
    existing_respondent_header_auth = { :Authorization => "Bearer #{get_user_access_token("respondent_user_seed@test.com")}" }
    respondent2 = User.find_by(:email => "respondent2_user_seed@test.com")
    respondent2_header_auth = { :Authorization => "Bearer #{get_user_access_token("respondent2_user_seed@test.com")}" }

    owner = User.find_by(:email => "owner_user_seed@test.com")
    owner_header_auth = owner_header_auth = { :Authorization => "Bearer #{get_user_access_token("owner_user_seed@test.com")}" }

    conversation = Conversation.find_by(:owner_user_id => owner.id, :respondent_user_id => existing_respondent.id)
    help_request = HelpRequest.find_by(:title => "Test seed title")

    # Create conversation
    describe "POST #create" do
        it "returns new conversation" do
            post conversations_route, params: {:target_user_id => owner.id, :help_request_id => help_request.id}, headers: respondent2_header_auth
            expect(response).to have_http_status(201) 
            expect(JSON.parse(response.body).keys).to contain_exactly("created_at", "help_request_id", "help_request_title", "id", "target_user_first_name", "target_user_id", "target_user_last_name", "timestamp", "total_messages", "unread_messages", "updated_at")
        end
        it "prevents duplicated conversation" do
            post conversations_route, params: {:target_user_id => owner.id, :help_request_id => help_request.id}, headers: existing_respondent_header_auth
            expect(response).to have_http_status(400) 
            expect(JSON.parse(response.body)["error"]["server_code"]).to eql(40001)
        end
        it "prevents outsider" do
            post conversations_route, params: {:target_user_id => owner.id, :help_request_id => help_request.id}, headers: outsider_header_auth
            expect(response).to have_http_status(400) 
            expect(JSON.parse(response.body)["error"]["server_code"]).to eql(40001)
        end
        it "prevents conversation between respondents" do
            post conversations_route, params: {:target_user_id => respondent2.id, :help_request_id => help_request.id}, headers: existing_respondent_header_auth
            expect(response).to have_http_status(400) 
            expect(JSON.parse(response.body)["error"]["server_code"]).to eql(40001)
        end
    end

    # All conversations related to user
    describe "GET #index" do
        it "returns success response" do
            get conversations_route, params: {}, headers: owner_header_auth
            expect(response).to be_successful 
        end
        it "returns non-empty array" do
            get conversations_route, params: {}, headers: owner_header_auth
            expect(JSON.parse(response.body).length).to be > 0
        end
        it "returns JSON" do
            get conversations_route, params: {}, headers: owner_header_auth
            expect(response.content_type).to include("application/json") 
        end
        it "returns public keys" do
            get conversations_route, params: {}, headers: owner_header_auth
            JSON.parse(response.body).each do |req|
                expect(req.keys).to contain_exactly("created_at", "help_request_id", "help_request_title", "id", "target_user_first_name", "target_user_id", "target_user_last_name", "total_messages", "unread_messages", "updated_at")
            end
        end
    end

    # Full content of a given conversation
    describe "GET #show" do
        it "prevents response to outsider of the conversation" do
            get "#{conversations_route}/#{conversation.id}", params: {}, headers: outsider_header_auth
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)["error"]["server_code"]).to eql(40001)
        end
        it "returns success response" do
            get "#{conversations_route}/#{conversation.id}", params: {}, headers: owner_header_auth
            expect(response).to be_successful 
        end
        it "returns non-empty array" do
            get "#{conversations_route}/#{conversation.id}", params: {}, headers: owner_header_auth
            expect(JSON.parse(response.body).length).to be > 0
        end
        it "returns JSON" do
            get "#{conversations_route}/#{conversation.id}", params: {}, headers: owner_header_auth
            expect(response.content_type).to include("application/json") 
        end
        it "returns public keys" do
            get "#{conversations_route}/#{conversation.id}", params: {}, headers: owner_header_auth
            JSON.parse(response.body).each do |req|
                expect(req.keys).to contain_exactly("conversation_id", "created_at", "id", "message", "status", "updated_at", "user_first_name", "user_id", "user_last_name")
            end
        end
    end

end
