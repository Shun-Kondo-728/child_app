require "rails_helper"

RSpec.describe "User list page", type: :request do
  let!(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }

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

  it "admin属性の変更が禁止されていること" do
    login_for_request(user)
    expect(user.admin).to be_falsey
    patch user_path(user), params: { user: { password: user.password,
                                             password_confirmation: user.password,
                                             admin: true } }
    expect(user.reload.admin).to be_falsey
  end
end
