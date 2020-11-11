require 'rails_helper'

RSpec.describe "Messages", type: :request do
  let!(:user) { create(:user) }
  let!(:message) { create(:message) }

  context "register talks" do
    context "if you are logged in" do
    end

    context "if you are not logged in" do
      it "messages cannot be deleted and redirect to the login page" do
        expect {
          delete message_path(message)
        }.not_to change(Message, :count)
      end
    end
  end
end
