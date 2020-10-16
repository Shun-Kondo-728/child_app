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

      it "Login button is displayed" do
        expect(page).to have_button 'ログイン'
      end
    end
  end
end
