require "rails_helper"

RSpec.describe "post page", type: :request do
  let!(:user) { create(:user) }
  let!(:new_post) { create(:post, user: user) }

  context "for authorized users" do
    it "the response is displayed normally" do
      login_for_request(user)
      get post_path(new_post)
      expect(response).to have_http_status "200"
      expect(response).to render_template('posts/show')
    end
  end

  context "for users who are not logged in" do
    it "redirect to login screen" do
      get new_post_path(new_post)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
