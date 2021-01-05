require "rails_helper"

RSpec.describe "problem post page", type: :request do
  let!(:user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }

  context "for authorized users" do
    it "the response is displayed normally" do
      login_for_request(user)
      get problem_path(problem)
      expect(response).to have_http_status "200"
      expect(response).to render_template('problems/show')
    end
  end

  context "for users who are not logged in" do
    it "redirect to login screen" do
      get new_problem_path(problem)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
