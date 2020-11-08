require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:new_post) { create(:post) }
  let!(:comment) { create(:comment, user_id: user.id, post: new_post) }

  context "register comments" do
    context "if you are logged in" do
    end

    context "if you are not logged in" do
      it "comments cannot be registered and redirect to the login page" do
        expect {
          post comments_path, params: { post_id: new_post.id,
                                        comment: { content: "最高です！" } }
        }.not_to change(new_post.comments, :count)
        expect(response).to redirect_to login_path
      end
    end
  end

  context "delete comment" do
    context "if you are logged in" do
    end

    context "if you are not logged in" do
      it "comments cannot be deleted and redirect to the login page" do
        expect {
          delete comment_path(comment)
        }.not_to change(new_post.comments, :count)
      end
    end
  end
end
