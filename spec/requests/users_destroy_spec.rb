require "rails_helper"

RSpec.describe "Delete user", type: :request do
  let!(:admin_user) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:new_post) { create(:post, user: user) }
  let!(:message) { create(:message, user: user) }
  let!(:membership) { create(:membership, user: user) }

  context "When the user associated with the dish is deleted" do
    it "Dishes associated with the user are also deleted" do
      login_for_request(user)
      expect {
        delete user_path(user)
      }.to change(Post, :count).by(-1)
    end
  end

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

  context "メッセージが紐づくユーザーを削除した場合" do
    it "ユーザーと同時に紐づくメッセージも削除される" do
      login_for_request(user)
      expect {
        delete user_path(user)
      }.to change(Message, :count).by(-1)
    end
  end

  context "メンバーシップが紐づくユーザーを削除した場合" do
    it "ユーザーと同時に紐づくメンバーシップも削除される" do
      login_for_request(user)
      expect {
        delete user_path(user)
      }.to change(Membership, :count).by(-1)
    end
  end
end
