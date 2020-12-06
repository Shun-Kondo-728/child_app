require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:new_post) { create(:post, user: user) }
  let!(:other_new_post) { create(:post, user: other_user) }

  context "display of notification list page" do
    context "for logged-in users" do
      before do
        login_for_request(user)
      end

      it "the response is displayed normally" do
        get notifications_path
        expect(response).to render_template('notifications/index')
      end
    end

    context "for users who are not logged in" do
      it "redirect to login page" do
        get notifications_path
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end
  end

  context "notification processing" do
    before do
      login_for_request(user)
    end

    context "for user postsて" do
      it "notifications are created by like registration" do
        post "/likes/#{other_new_post.id}/create"
        expect(other_user.reload.active_notifications).to be_truthy
      end

      it "notifications are created by comments" do
        post comments_path, params: { post_id: other_new_post.id,
                                      comment: { content: "最高です！" } }
        expect(other_user.reload.active_notifications).to be_truthy
      end

      it "the follow creates a notification" do
        post relationships_path, params: { followed_id: other_user.id }
        expect(other_user.reload.active_notifications).to be_truthy
      end
    end
  end
end
