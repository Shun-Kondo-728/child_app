require "rails_helper"

RSpec.describe "Delete user", type: :request do
  let!(:admin_user) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  context "For admin users" do
    it "After deleting the user, redirect to the user list page" do
      login_for_request(admin_user)
      expect {
        delete user_path(user)
      }.to change(User, :count).by(-1)
      redirect_to users_url
      follow_redirect!
      expect(response).to render_template('users/index')
    end
  end

  context "For non-administrator users" do
    it "Being able to delete my account" do
      login_for_request(user)
      expect {
        delete user_path(user)
      }.to change(User, :count).by(-1)
      redirect_to root_url
    end

    it "Redirecting to the top page when trying to delete a user other than yourself" do
      login_for_request(user)
      expect {
        delete user_path(other_user)
      }.not_to change(User, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end

  context "For users who are not logged in" do
    it "Redirect to login page" do
      expect {
        delete user_path(user)
      }.not_to change(User, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
