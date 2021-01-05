require "rails_helper"

RSpec.describe "problem post edit", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }

  context "for authorized users" do
    it "the response is displayed normally" do
      get edit_problem_path(problem)
      login_for_request(user)
      expect(response).to redirect_to edit_problem_path(problem)
      patch problem_path(problem), params: { problem: { description: "こんな悩みがあります。" } }
      redirect_to problem
      follow_redirect!
      expect(response).to render_template('problems/show')
    end
  end

  context "for users who are not logged in" do
    it "redirect to login screen" do
      get edit_problem_path(problem)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
      patch problem_path(problem), params: { problem: { description: "こんな悩みがあります。" } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end

  context "for users of different accounts" do
    it "redirect to home screen" do
      login_for_request(other_user)
      get edit_problem_path(problem)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
      patch problem_path(problem), params: { problem: { description: "こんな悩みがあります。" } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end
end
