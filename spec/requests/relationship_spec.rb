require 'rails_helper'

RSpec.describe "user follow function", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  context "if you are logged in" do
    before do
      login_for_request(user)
    end

    it "being able to follow users" do
      expect {
        post relationships_path, params: { followed_id: other_user.id }
      }.to change(user.following, :count).by(1)
    end

    it "being able to follow users with Ajax" do
      expect {
        post relationships_path, xhr: true, params: { followed_id: other_user.id }
      }.to change(user.following, :count).by(1)
    end

    it "being able to unfollow users" do
      user.follow(other_user)
      relationship = user.active_relationships.find_by(followed_id: other_user.id)
      expect {
        delete relationship_path(relationship)
      }.to change(user.following, :count).by(-1)
    end

    it "being able to unfollow users with Ajax" do
      user.follow(other_user)
      relationship = user.active_relationships.find_by(followed_id: other_user.id)
      expect {
        delete relationship_path(relationship), xhr: true
      }.to change(user.following, :count).by(-1)
    end
  end

  context "if you are not logged in" do
    it "redirect to the login page when jumping to the following page" do
      get following_user_path(user)
      expect(response).to redirect_to login_path
    end

    it "redirect to login page when jumping to followers page" do
      get followers_user_path(user)
      expect(response).to redirect_to login_path
    end

    it "the create action cannot be executed and redirects to the login page" do
      expect {
        post relationships_path
      }.not_to change(Relationship, :count)
      expect(response).to redirect_to login_path
    end

    it "the destroy action cannot be performed and redirects to the login page" do
      expect {
        delete relationship_path(user)
      }.not_to change(Relationship, :count)
      expect(response).to redirect_to login_path
    end
  end
end
