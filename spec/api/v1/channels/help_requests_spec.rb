require "rails_helper"

RSpec.describe HelpRequestsChannel, type: :channel do

  it "rejects unauthenticated user" do
    begin
      subscribe
    rescue Exception => e 
    end
    expect(e).not_to eql(nil)
  end

  it "accepts only valid user" do
    stub_connection current_user: User.first
    subscribe
    expect(subscription).not_to be_rejected
  end

end
