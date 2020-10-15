require 'rails_helper'

RSpec.describe "Users", type: :system do
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
  end
end
