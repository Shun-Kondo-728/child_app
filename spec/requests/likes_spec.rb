require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let(:user) { create(:user) }
  let(:new_post) { create(:post) }

  context "like registration process" do
    context "if you are not logged in" do
      it "likes cannot be registered and redirect to the login page" do
        expect {
          post "/likes/#{new_post.id}/create"
        }.not_to change(Like, :count)
        expect(response).to redirect_to login_path
      end

      it "unlike cannot be executed and redirects to the login page" do
        expect {
          delete "/likes/#{new_post.id}/destroy"
        }.not_to change(Like, :count)
        expect(response).to redirect_to login_path
      end
    end
  end
end
