require 'rails_helper'

RSpec.describe Api::V1::FaqController, type: :controller do

    describe "GET #index" do
        it "returns success response" do
            get :index
            expect(response).to be_successful # Expects 200
        end

        it "returns non-empty array" do
            get :index
            expect(JSON.parse(response.body).length).to be > 0
        end

        it "returns JSON" do
            get :index
            expect(response.content_type).to include("application/json") 
        end

        it "returns keys" do
            get :index
            JSON.parse(response.body).each do |status|
                expect(status.keys).to contain_exactly("id", "keywords", "question", "response", "created_at", "updated_at")
            end
        end
    end

end
