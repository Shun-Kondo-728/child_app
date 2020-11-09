require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:new_post) { create(:post) }
  let!(:comment) { create(:comment, user_id: user.id, post: new_post) }

  context "register comments" do
    context "if you are logged in" do
      before do
        login_for_request(user)
      end

      it "comments with valid content can be registered" do
        expect {
          post comments_path, params: { post_id: new_post.id,
                                        comment: { content: "最高です！" } }
        }.to change(new_post.comments, :count).by(1)
      end

      it "comments with invalid content cannot be registered" do
        expect {
          post comments_path, params: { post_id: new_post.id,
                                        comment: { content: "" } }
        }.not_to change(new_post.comments, :count)
      end
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
      context "if you are the user who created the comment" do
        it "being able to delete comments" do
          login_for_request(user)
          expect {
            delete comment_path(comment)
          }.to change(new_post.comments, :count).by(-1)
        end
      end

      context "if you are not the user who created the comment" do
        it "comments cannot be deleted" do
          login_for_request(other_user)
            expect {
              delete comment_path(comment)
            }.not_to change(new_post.comments, :count)
        end
      end
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
