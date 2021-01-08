require 'rails_helper'

RSpec.describe "ProblemComments", type: :request do
  let!(:user) { create(:user) }
  let!(:problem) { create(:problem) }
  let!(:problem_comment) { create(:problem_comment, user_id: user.id, problem: problem) }

  context "register comments" do
    context "if you are logged in" do
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
