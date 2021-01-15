require "rails_helper"

RSpec.describe "Post search list", type: :request do
  let!(:user) { create(:user) }
  let!(:new_post) { create(:post, user: user) }

  context "for logged-in users" do
    it "the response is displayed normally" do
      login_for_request(user)
      get posts_path
      expect(response).to have_http_status "200"
      expect(response).to render_template('posts/index')
    end
  end

  context "for users who are not logged in" do
    it "redirect to login screen" do
      get posts_path
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
