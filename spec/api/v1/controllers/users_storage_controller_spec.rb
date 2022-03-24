require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do

    header_auth = { :Authorization => "Bearer #{get_user_access_token("profile_user_seed@test.com")}" }
    users_storage_route = "/fishforhelp/api/v1/users/storage"

    # POST - Create user storage
    it "create storage: valid .png" do
        post users_storage_route, params: { file_type: "government_id", "file" => Rack::Test::UploadedFile.new("spec/support/files/valid.png") }, headers: header_auth
        expect(response).to have_http_status(201)
    end
    it "create storage: valid .pdf" do
        post users_storage_route, params: { file_type: "government_id", "file" => Rack::Test::UploadedFile.new("spec/support/files/valid.pdf") }, headers: header_auth
        expect(response).to have_http_status(201)
    end
    it "create storage: invalid extension" do
        post users_storage_route, params: { file_type: "government_id", "file" => Rack::Test::UploadedFile.new("spec/support/files/invalid.txt") }, headers: header_auth
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)["error"]["server_code"]).to eql(40002)
    end
    it "returns JSON" do
        post users_storage_route, params: { file_type: "government_id", "file" => Rack::Test::UploadedFile.new("spec/support/files/valid.png") }, headers: header_auth
        expect(response.content_type).to include("application/json") 
    end
    it "returns keys" do
        post users_storage_route, params: { file_type: "government_id", "file" => Rack::Test::UploadedFile.new("spec/support/files/valid.png") }, headers: header_auth
        expect(JSON.parse(response.body).keys).to contain_exactly("gov_id", "timestamp")
    end

end
