require 'rails_helper'

RSpec.describe "Relationships", type: :system do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:user4) { create(:user) }
  let!(:new_post) { create(:post, user: user) }
  let!(:new_post2) { create(:post, user: user2) }
  let!(:new_post3) { create(:post, user: user3) }

  describe "following page" do
    before do
      create(:relationship, follower_id: user.id, followed_id: user2.id)
      create(:relationship, follower_id: user.id, followed_id: user3.id)
      login_for_system(user)
      visit following_user_path(user)
    end

    context "page layout" do
      it "the following string exists" do
        expect(page).to have_content 'フォロー中'
      end

      it "the correct title is displayed" do
        expect(page).to have_title full_title('フォロー中')
      end

      it "user information is displayed" do
        expect(page).to have_content user.name
        expect(page).to have_link "プロフィール", href: user_path(user)
        expect(page).to have_content "投稿#{user.posts.count}件"
        expect(page).to have_link "#{user.following.count}人をフォロー", href: following_user_path(user)
        expect(page).to have_link "#{user.followers.count}人のフォロワー", href: followers_user_path(user)
      end

      it "the user you are following is displayed" do
        within find('.users') do
          expect(page).to have_css 'li', count: user.following.count
          user.following.each do |u|
            expect(page).to have_link u.name, href: user_path(u)
          end
        end
      end
    end
  end

  describe "followers page" do
    before do
      create(:relationship, follower_id: user2.id, followed_id: user.id)
      create(:relationship, follower_id: user3.id, followed_id: user.id)
      create(:relationship, follower_id: user4.id, followed_id: user.id)
      login_for_system(user)
      visit followers_user_path(user)
    end

    context "page layout" do
      it "The existence of the follower string" do
        expect(page).to have_content 'フォロワー'
      end

      it "the correct title is displayed" do
        expect(page).to have_title full_title('フォロワー')
      end

      it "user information is displayed" do
        expect(page).to have_content user.name
        expect(page).to have_link "プロフィール", href: user_path(user)
        expect(page).to have_content "投稿#{user.posts.count}件"
        expect(page).to have_link "#{user.following.count}人をフォロー", href: following_user_path(user)
        expect(page).to have_link "#{user.followers.count}人のフォロワー", href: followers_user_path(user)
      end

      it "the followers are displayed" do
        within find('.users') do
          expect(page).to have_css 'li', count: user.followers.count
          user.followers.each do |u|
            expect(page).to have_link u.name, href: user_path(u)
          end
        end
      end
    end
  end

  describe "feed" do
    before do
      create(:relationship, follower_id: user.id, followed_id: user2.id)
      login_for_system(user)
    end

    it "your feed contains your post" do
      expect(user.feed).to include new_post
    end

    it "your feed contains posts from users you're following" do
      expect(user.feed).to include new_post2
    end

    it "the feed does not contain posts from users you do not follow" do
      expect(user.feed).not_to include new_post3
    end
  end
end
