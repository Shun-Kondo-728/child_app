require "rails_helper"

RSpec.describe "delete post", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:new_post) { create(:post, user: user) }

  context "if you are logged in and want to delete your post" do
    it "the process is successful and you are redirected to the top page" do
      login_for_request(user)
      expect {
        delete post_path(new_post)
      }.to change(Post, :count).by(-1)
      redirect_to user_path(user)
      follow_redirect!
      expect(response).to render_template('static_pages/home')
    end
  end

  context "if you are logged in and want to delete someone else's post" do
    it "processing fails and redirects to the top page" do
      login_for_request(other_user)
      expect {
        delete post_path(new_post)
      }.not_to change(Post, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end

  context "if you are not logged in" do
    it "redirect to login page" do
      expect {
        delete post_path(new_post)
      }.not_to change(Post, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
