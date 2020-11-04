require 'rails_helper'

RSpec.describe "user follow function", type: :request do
  let(:user) { create(:user) }

  context "if you are not logged in" do
    it "redirect to the login page when jumping to the following page" do
      get following_user_path(user)
      expect(response).to redirect_to login_path
    end

    it "redirect to login page when jumping to followers page" do
      get followers_user_path(user)
      expect(response).to redirect_to login_path
    end
  end
end
