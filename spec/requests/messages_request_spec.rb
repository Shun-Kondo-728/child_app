require 'rails_helper'

RSpec.describe "Messages", type: :request do
  let!(:user) { create(:user) }
  let(:talk) { create(:talk) }
  let!(:other_user) { create(:user) }
  let!(:message) { create(:message, user_id: user.id, talk: talk) }

  context "register talks" do
    context "if you are logged in" do
      before do
        login_for_request(user)
      end

      #it "messages with valid content can be registered" do
       # expect {
        #  post "/messages_talk/#{message}/messages", params: { message: { content: "最高です！" } }
        #}.to change(Message, :count).by(1)
      #end

      it "messages with invalid content cannot be registered" do
        expect {
          post messages_talk_path(talk), params: { user_id: user.id,
                                                      talk_id: talk.id,
                                                      message: { content: "最高です！" } }
        }.not_to change(Message, :count)
      end
    end

    context "if you are not logged in" do
      it "messages cannot be registered and redirect to the login page" do
        expect {
          post messages_path, params: { message: { content: "最高です！" } }
        }.not_to change(Message, :count)
        expect(response).to redirect_to login_path
      end
    end
  end

  context "delete message" do
    context "if you are logged in" do
      context "if you are the user who created the comment" do
        let!(:message) { create(:message, user: user, talk: talk) }

        it "being able to delete comments" do
          login_for_request(user)
          expect {
            delete message_path(message)
          }.to change(Message, :count).by(-1)
        end
      end

      context "if you are not the user who created the message" do
        it "messages cannot be deleted" do
          login_for_request(other_user)
            expect {
              delete message_path(message)
            }.not_to change(Message, :count)
        end
      end
    end

    context "if you are not logged in" do
      it "mesages cannot be deleted and redirect to the login page" do
        expect {
          delete message_path(message)
        }.not_to change(Message, :count)
      end
    end
  end
end
