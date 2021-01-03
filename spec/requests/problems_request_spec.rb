require 'rails_helper'

RSpec.describe "Problems", type: :request do
  let!(:user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }

  context "for logged-in users" do
    it "the response is displayed normally" do
      login_for_request(user)
      get new_problem_path
      expect(response).to have_http_status "200"
      expect(response).to render_template('problems/new')
    end
  end

  context "for users who are not logged in" do
    it "redirect to login screen" do
      get new_problem_path
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
