require 'rails_helper'

RSpec.describe Api::V1::UsersMailerController, type: :request do

    request_params = add_app_params({:email => "profile_user_seed@test.com"})
    users_mailer_route_prefix = "/api/v1/users/mailer"

    # POST - Send email
    it "send account confirmation" do
        post "#{users_mailer_route_prefix}/send_confirmation", params: request_params
        expect(response).to have_http_status(201)
    end
    it "send forgot password" do
        post "#{users_mailer_route_prefix}/forgot_password", params: request_params
        expect(response).to have_http_status(201)
    end
    request_params_fake_email = add_app_params({:email => "fake@test.com"})
    it "email not found" do
        post "#{users_mailer_route_prefix}/forgot_password", params: request_params_fake_email
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]["server_code"]).to eql(40004)
    end
    it "invalid subaction" do
        post "#{users_mailer_route_prefix}/fake_action", params: request_params
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]["server_code"]).to eql(40001)
    end

end
