require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let!(:user) { create(:user) }

  describe "post page" do
    before do
      login_for_system(user)
      visit new_post_path
    end

    context "page layout" do
      it "the post string is present" do
        expect(page).to have_content '投稿'
      end

      it "the correct title is displayed" do
        expect(page).to have_title full_title('投稿')
      end

      it "appropriate label is displayed in the input part" do
        expect(page).to have_content 'タイトル'
        expect(page).to have_content '説明'
        expect(page).to have_content 'オススメ度'
      end
    end

    context "post processing" do
        it "if you post with valid information, a flash of successful posting will be displayed" do
          fill_in "post[title]", with: "赤ちゃんが泣き止む曲"
          fill_in "説明", with: "この曲が、一番オススメです！"
          fill_in "オススメ度", with: 4
          click_button "投稿する"
          expect(page).to have_content "投稿されました！"
        end

        it "when posting with invalid information, a flash of posting failure is displayed" do
          fill_in "post[title]", with: ""
          fill_in "説明", with: ""
          fill_in "オススメ度", with: 4
          click_button "投稿する"
          expect(page).to have_content "タイトルを入力してください"
          expect(page).to have_content "説明を入力してください"
        end
    end
  end
end
