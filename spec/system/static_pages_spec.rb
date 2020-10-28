require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "top page" do
    context "whole page" do
      before do
        visit root_path
      end

      it "confirm that the chillshare string exists" do
        expect(page).to have_content 'チルシェア'
      end

      it "make sure the correct title is displayed" do
        expect(page).to have_title full_title
      end
    end

    context "post feed", js: true do
      let!(:user) { create(:user) }
      let!(:new_post) { create(:post, user: user) }

      it "post pagination should be displayed" do
        login_for_system(user)
        create_list(:post, 20, user: user)
        visit root_path
        expect(page).to have_content "ユーザーの投稿 (#{user.posts.count})"
        expect(page).to have_css ".pagination"
        Post.take(10).each do |d|
          expect(page).to have_link d.title
        end
      end
    end
  end
end
