require 'rails_helper'

RSpec.describe "Problems", type: :request do
  let!(:user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }

  context "for logged-in users" do
    before do
      get new_problem_path
      login_for_request(user)
    end

    context "friendly forwarding" do
      it "the response is displayed normally" do
        expect(response).to redirect_to new_problem_url
      end
    end

    it "being able to register with valid problem post data" do
      expect {
        post problems_path, params: { problem: { description: "こんな悩みがあります。" } }
      }.to change(Problem, :count).by(1)
      follow_redirect!
      expect(response).to render_template('problems/index')
    end

    it "cannot be registered with invalid problem post data" do
      expect {
        post problems_path, params: { problem: { description: "" } }
      }.not_to change(Problem, :count)
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
