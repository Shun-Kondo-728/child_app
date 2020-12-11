require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:new_post) { create(:post, user: user) }
  let!(:other_new_post) { create(:post, user: other_user) }
  let!(:admin_user) { create(:user, :admin) }

  describe "User list page" do
    it "pagination" do
      create_list(:user, 31)
      login_for_system(user)
      visit users_path
      expect(page).to have_css ".pagination"
    end
  end

  describe "signup page" do
    before do
      visit signup_path
    end

    it "confirm that the sign up string exists" do
      expect(page).to have_content '新規登録'
    end

    it "make sure the correct title is displayed" do
      expect(page).to have_title full_title('新規登録')
    end

    context "User registration process" do
      it "A flash of success is displayed when registering as a valid user" do
        fill_in "名前", with: "Example User"
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "登録"
        expect(page).to have_content "Chi-Shaへようこそ！"
      end

      it "When registering as an invalid user, a flash of user registration failure is displayed" do
        fill_in "名前", with: ""
        fill_in "メールアドレス", with: "user@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "pass"
        click_button "登録"
        expect(page).to have_content "名前を入力してください"
        expect(page).to have_content "パスワード(確認)とパスワードの入力が一致しません"
      end
    end
  end

  describe "Profile edit page" do
    before do
      login_for_system(user)
      visit user_path(user)
      click_link "プロフィール編集"
    end

    context "Account deletion process", js: true do
      it "What can be deleted correctly" do
        click_link "アカウントを削除する"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "自分のアカウントを削除しました"
      end
    end

    context "Page layout" do
      it "Make sure the correct title is displayed" do
        expect(page).to have_title full_title('プロフィール編集')
      end
    end

    it "A flash of successful updates is displayed after a valid profile update" do
      fill_in "名前", with: "Edit Example User"
      fill_in "メールアドレス", with: "edit-user@example.com"
      fill_in "自己紹介", with: "編集：お願いします"
      click_button "更新する"
      expect(page).to have_content "プロフィールが更新されました！"
      expect(user.reload.name).to eq "Edit Example User"
      expect(user.reload.email).to eq "edit-user@example.com"
      expect(user.reload.introduction).to eq "編集：お願いします"
    end

    it "Appropriate error message is displayed when trying to update an invalid profile" do
      fill_in "名前", with: ""
      fill_in "メールアドレス", with: ""
      click_button "更新する"
      expect(page).to have_content '名前を入力してください'
      expect(page).to have_content 'メールアドレスを入力してください'
      expect(page).to have_content 'メールアドレスは不正な値です'
      expect(user.reload.email).not_to eq ""
    end
  end

  describe "Profile page" do
    context "Page layout" do
      before do
        login_for_system(user)
        create_list(:post, 20, user: user)
        visit user_path(user)
      end

      it "Make sure the correct title is displayed" do
        expect(page).to have_title full_title('プロフィール')
      end

      it "Confirm that user information is displayed" do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
      end

      it "Confirm that the number of posts is displayed" do
        expect(page).to have_content "投稿 (#{user.posts.count})"
      end

      it "Confirm that the post information is displayed" do
        Post.take(10).each do |post|
          expect(page).to have_link post.title
          expect(page).to have_content post.description
        end
      end

      it "Make sure the post pagination is displayed" do
        expect(page).to have_css ".pagination"
      end
    end

    context "user follow / unfollow process", js: true do
      it "being able to follow / unfollow users" do
        login_for_system(user)
        visit user_path(other_user)
        expect(page).to have_button 'フォローする'
        click_button 'フォローする'
        expect(page).to have_button 'フォロー中'
        click_button 'フォロー中'
        expect(page).to have_button 'フォローする'
      end
    end

    context "like registration / cancellation" do
      before do
        login_for_system(user)
      end

      it "being able to register / unfavorite posts" do
        expect(user.like?(new_post)).to be_falsey
        user.like(new_post)
        expect(user.like?(new_post)).to be_truthy
        user.unlike(new_post)
        expect(user.like?(new_post)).to be_falsey
      end

      it "being able to register / cancel likes from the top page", js: true do
        visit root_path
        link = find('.like')
        expect(link[:href]).to include "/likes/#{new_post.id}/create"
        link.click
        link = find('.unlike')
        expect(link[:href]).to include "/likes/#{new_post.id}/destroy"
        link.click
        link = find('.like')
        expect(link[:href]).to include "/likes/#{new_post.id}/create"
      end

      it "being able to register / cancel likes from the individual user page", js: true do
        visit user_path(user)
        link = find('.like')
        expect(link[:href]).to include "/likes/#{new_post.id}/create"
        link.click
        link = find('.unlike')
        expect(link[:href]).to include "/likes/#{new_post.id}/destroy"
        link.click
        link = find('.like')
        expect(link[:href]).to include "/likes/#{new_post.id}/create"
      end

      it "being able to register / cancel likes from the individual post page", js: true do
        visit post_path(new_post)
        link = find('.like')
        expect(link[:href]).to include "/likes/#{new_post.id}/create"
        link.click
        link = find('.unlike')
        expect(link[:href]).to include "/likes/#{new_post.id}/destroy"
        link.click
        link = find('.like')
        expect(link[:href]).to include "/likes/#{new_post.id}/create"
      end

      it "the likes list page is displayed as expected" do
        visit likes_path
        expect(page).not_to have_css ".like-post"
        user.like(new_post)
        user.like(other_new_post)
        visit likes_path
        expect(page).to have_css ".like-post", count: 2
        expect(page).to have_content new_post.title
        expect(page).to have_content new_post.description
        expect(page).to have_content "posted by #{user.name}"
        expect(page).to have_link user.name, href: user_path(user)
        expect(page).to have_content other_new_post.title
        expect(page).to have_content other_new_post.description
        expect(page).to have_content "posted by #{other_user.name}"
        expect(page).to have_link other_user.name, href: user_path(other_user)
        user.unlike(other_new_post)
        visit likes_path
        expect(page).to have_css ".like-post", count: 1
        expect(page).to have_content new_post.title
      end
    end

    context "notification generation" do
      before do
        login_for_system(user)
      end

      context "for users other than yourself" do
        before do
          visit post_path(other_new_post)
        end

        it "notifications are created by like registration" do
          find('.like').click
          visit post_path(other_new_post)
          logout
          login_for_system(other_user)
          visit notifications_path
          expect(page).to have_content "#{user.name}があなたの投稿にいいねしました"
        end

        it "notifications are created by being followed" do
          visit user_path(other_user)
          click_button "フォローする"
          logout
          login_for_system(other_user)
          visit notifications_path
          expect(page).to have_content "#{user.name}があなたをフォローしました"
        end

        it "notifications are created by comments" do
          fill_in "comment_content", with: "コメントしました"
          click_button "コメント"
          logout
          login_for_system(other_user)
          visit notifications_path
          expect(page).to have_content "#{user.name}が#{other_new_post.title}にコメントしました"
          expect(page).to have_content 'コメントしました'
        end
      end
    end
  end
end
