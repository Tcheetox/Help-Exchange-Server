require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do

    header_auth = { :Authorization => "Bearer #{get_user_access_token("profile_user_seed@test.com")}" }
    users_route = "/fishforhelp/api/v1/users"

    # GET - User profile
    it "returns user profile" do
        get users_route, params: {}, headers: header_auth
        expect(response).to be_successful # Expects 200
    end
    it "returns JSON" do
        get users_route, params: {}, headers: header_auth
        expect(response.content_type).to include("application/json") 
    end
    it "returns keys" do
        get users_route, params: {}, headers: header_auth
        expect(JSON.parse(response.body).keys).to contain_exactly("created_at", "address", "completed", "country", "email", "first_name", "gov_id", "last_name", "lat", "lng", "phone", "post_code", "timestamp")
    end

    # PUT - Update
    it "update password" do
        put users_route, params: {:current_password => "azerty", :password => "azerty"}, headers: header_auth
        expect(response).to have_http_status(204)
    end
    it "update password: cannot be blank" do
        put users_route, params: {:current_password => "azerty", :password => ""}, headers: header_auth
        expect(response).to have_http_status(403)
    end
    it "update password: cannot be < 6 chars" do
        put users_route, params: {:current_password => "azerty", :password => "aze"}, headers: header_auth
        expect(response).to have_http_status(403)
    end
    it "update password: current password must be valid" do
        put users_route, params: {:current_password => "aze", :password => "azerty"}, headers: header_auth
        expect(response).to have_http_status(403)
    end

    # PUT - Update profile
    it "update profile" do
        new_first_name = "Test user 12345"
        put users_route, params: {:first_name => new_first_name}, headers: header_auth
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["first_name"]).to eql(new_first_name)
    end
    it "update profile: returns keys" do
        put users_route, params: {:first_name => "Test user132"}, headers: header_auth
        expect(JSON.parse(response.body).keys).to contain_exactly("created_at", "address", "completed", "country", "email", "first_name", "gov_id", "last_name", "lat", "lng", "phone", "post_code", "timestamp")
    end
    it "update profile: returns JSON" do
        put users_route, params: {:first_name => "Test user132"}, headers: header_auth
        expect(response.content_type).to include("application/json") 
    end

    # DELETE - Soft delete user
    it "destroy user" do
        delete users_route, params: {}, headers: header_auth
        expect(response).to have_http_status(204) 
    end
    it "destroyed user: token revoked" do
        delete users_route, params: {}, headers: header_auth
        get users_route, params: {}, headers: header_auth
        expect(response).to have_http_status(401) 
    end

    # POST - Create user
    new_user_params = add_app_params({:email => "create_user@test.com", :password => "azerty"})
    it "create user" do
        post users_route, params: new_user_params
        expect(response).to have_http_status(201) 
    end
    it "create user: must be unique" do
        post users_route, params: new_user_params
        post users_route, params: new_user_params
        expect(response).to have_http_status(422) 
    end
    new_user_params_blank_email = add_app_params({:email => "", :password => "azerty"})
    it "create user: email cannot be blank" do
        post users_route, params: new_user_params_blank_email
        expect(response).to have_http_status(400) 
    end
    new_user_params_blank_password = add_app_params({:email => "create_user@test.com", :password => ""})
    it "create user: password cannot be blank" do
        post users_route, params: new_user_params_blank_password
        expect(response).to have_http_status(422) 
    end
    new_user_params_unsafe_password = add_app_params({:email => "create_user@test.com", :password => "aze"})
    it "create user: password cannot be < 6 chars" do
        post users_route, params: new_user_params_unsafe_password
        expect(response).to have_http_status(422) 
    end

end
