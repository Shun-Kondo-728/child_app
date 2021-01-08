require 'rails_helper'

RSpec.describe "ProblemComments", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:problem) { create(:problem) }
  let!(:problem_comment) { create(:problem_comment, user_id: user.id, problem: problem) }

  context "register problem_comments" do
    context "if you are logged in" do
      before do
        login_for_request(user)
      end

      it "problem_comments with valid content can be registered" do
        expect {
          post problem_comments_path, params: { problem_id: problem.id,
                                        problem_comment: { content: "そうなんですね。" } }
        }.to change(problem.problem_comments, :count).by(1)
      end

      it "problem_comments with invalid content cannot be registered" do
        expect {
          post problem_comments_path, params: { problem_id: problem.id,
                                        problem_comment: { content: "" } }
        }.not_to change(problem.problem_comments, :count)
      end
    end

    context "if you are not logged in" do
      it "problem_comments cannot be registered and redirect to the login page" do
        expect {
          post problem_comments_path, params: { problem_id: problem.id,
                                        comment: { content: "最高です！" } }
        }.not_to change(problem.problem_comments, :count)
        expect(response).to redirect_to login_path
      end
    end
  end

  context "delete comment" do
    context "if you are logged in" do
      context "if you are the user who created the problem_comment" do
        it "being able to delete problem_comments" do
          login_for_request(user)
          expect {
            delete problem_comment_path(problem_comment)
          }.to change(problem.problem_comments, :count).by(-1)
        end
      end

      context "if you are not the user who created the problem_comment" do
        it "problem_comments cannot be deleted" do
          login_for_request(other_user)
            expect {
              delete problem_comment_path(problem_comment)
            }.not_to change(problem.problem_comments, :count)
        end
      end
    end

    context "if you are not logged in" do
      it "problem_comments cannot be deleted and redirect to the login page" do
        expect {
          delete problem_comment_path(problem_comment)
        }.not_to change(problem.problem_comments, :count)
      end
    end
  end
end
