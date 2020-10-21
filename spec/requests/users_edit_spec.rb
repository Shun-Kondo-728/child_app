require "rails_helper"

RSpec.describe "Profile edit", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  context "For authorized users" do
    it "The response is displayed normally" do
      login_for_request(user)
      get edit_user_path(user)
      expect(response).to render_template('users/edit')
      patch user_path(user), params: { user: { name: "Example User",
                                               email: "user@example.com",
                                               introduction: "お願いします" } }
      redirect_to user
      follow_redirect!
      expect(response).to render_template('users/show')
    end
  end

  context "For users who are not logged in" do
    it "Redirect to login screen" do
      # 編集
      get edit_user_path(user)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
      # 更新
      patch user_path(user), params: { user: { name: user.name,
                                               email: user.email } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end

  context "For users of different accounts" do
    it "Redirect to home screen" do
      # 編集
      login_for_request(other_user)
      get edit_user_path(user)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
      # 更新
      patch user_path(user), params: { user: { name: user.name,
                                               email: user.email } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end
end
