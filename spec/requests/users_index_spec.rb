require "rails_helper"

RSpec.describe "User list page", type: :request do
  let!(:user) { create(:user) }

  context "For authorized users" do
    it "The response is displayed normally" do
      login_for_request(user)
      get users_path
      expect(response).to render_template('users/index')
    end
  end

  context "For users who are not logged in" do
    it "Redirect to login page" do
      get users_path
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
