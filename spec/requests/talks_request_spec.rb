require 'rails_helper'

RSpec.describe "Talks", type: :request do
  let!(:user) { create(:user) }
  let!(:message) { create(:message) }

  context "register talks" do
    context "if you are logged in" do
    end

    context "if you are not logged in" do
      it "redirect to login page when jumping to show page" do
        get talk_path(user)
        expect(response).to redirect_to login_path
      end

      it "talks cannot be registered and redirect to the login page" do
        expect {
          post talks_path
        }.not_to change(Talk, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
end
