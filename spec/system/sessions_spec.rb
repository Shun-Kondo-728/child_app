require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let!(:user) { create(:user) }

  before do
    visit login_path
  end

  describe "Login page" do
    context "Page layout" do
      it "「Make sure the login string exists" do
        expect(page).to have_content 'ログイン'
      end

      it "Make sure the correct title is displayed" do
        expect(page).to have_title full_title('ログイン')
      end

      it "
      Make sure there is a link to the login page in the header" do
        expect(page).to have_link 'ログイン', href: login_path
      end

      it "Login form label is displayed correctly" do
        expect(page).to have_content 'メールアドレス'
        expect(page).to have_content 'パスワード'
      end

      it "Login form is displayed correctly" do
        expect(page).to have_css 'input#user_email'
        expect(page).to have_css 'input#user_password'
      end

      it "The Keep me logged in checkbox is displayed" do
        expect(page).to have_content 'ログインしたままにする'
        expect(page).to have_css 'input#session_remember_me'
      end

      it "Login button is displayed" do
        expect(page).to have_button 'ログイン'
      end
    end
  end

  context "Login process" do
    it "Confirm that login fails when logging in as an invalid user" do
      fill_in "user_email", with: "user@example.com"
      fill_in "user_password", with: "pass"
      click_button "ログイン"
      expect(page).to have_content 'メールアドレスとパスワードの組み合わせが間違っています'

      visit root_path
      expect(page).not_to have_content "メールアドレスとパスワードの組み合わせが間違っています"
    end

    it "The header is displayed correctly before and after logging in as a valid user" do
      expect(page).to have_link '新規登録', href: signup_path
      expect(page).to have_link 'ログイン', href: login_path
      expect(page).not_to have_link 'ログアウト', href: logout_path

      fill_in "user_email", with: user.email
      fill_in "user_password", with: user.password
      click_button "ログイン"

      expect(page).to have_link 'ユーザー一覧', href: users_path
      expect(page).to have_link 'プロフィール', href: user_path(user)
      expect(page).to have_link 'ログアウト', href: logout_path
      expect(page).not_to have_link 'ログイン', href: login_path
    end
  end
end
