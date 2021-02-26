require "rails_helper"

RSpec.describe MessagesChannel, type: :channel do

  it "rejects unauthenticated user" do
    begin
      subscribe
    rescue Exception => e 
    end
    expect(e).not_to eql(nil)
  end

  it "rejects users not related to conversation" do
    target_conversation = Conversation.find_by(:owner_user_id => User.find_by(:email => "owner_user_seed@test.com").id)
    stub_connection(current_user: User.find_by(:email => "unrelated_user_seed@test.com"), conversation: target_conversation)
    subscribe
    expect(subscription).to be_rejected
  end

end
