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

      before do
        login_for_system(user)
      end

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

      it "the link to post is displayed" do
        visit root_path
        expect(page).to have_link "投稿する", href: new_post_path
      end

      it "after deleting a post, a flash of successful deletion is displayed" do
        visit root_path
        click_on '削除'
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '投稿が削除されました'
      end
    end
  end
end
