require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }

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

  describe "Profile page" do
    context "Page layout" do
      before do
        visit user_path(user)
      end

      it "Make sure the profile string exists" do
        expect(page).to have_content 'プロフィール'
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
