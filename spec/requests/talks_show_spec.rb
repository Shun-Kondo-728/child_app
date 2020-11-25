require "rails_helper"

RSpec.describe "post page", type: :request do
  let!(:user) { create(:user) }
  let!(:talk) { create(:talk) }

  context "for users who are not logged in" do
    it "redirect to login screen" do
      get talk_path(talk)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
