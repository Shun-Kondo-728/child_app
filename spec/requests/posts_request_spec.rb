require 'rails_helper'

RSpec.describe "Posts", type: :request do
    let!(:user) { create(:user) }
    let!(:new_post) { create(:post, user: user) }

    context "for logged-in users" do
      it "the response is displayed normally" do
        login_for_request(user)
        get new_post_path
        expect(response).to have_http_status "200"
        expect(response).to render_template('posts/new')
      end
    end

    context "for users who are not logged in" do
      it "redirect to login screen" do
        get new_post_path
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end
end
