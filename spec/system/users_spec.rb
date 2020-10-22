require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }

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
        visit user_path(user)
      end

      it "Make sure the correct title is displayed" do
        expect(page).to have_title full_title('プロフィール')
      end

      it "Confirm that user information is displayed" do
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
      end
    end
  end
end
