require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let!(:user) { create(:user) }
  let!(:problem) { create(:problem) }

  describe "profile page" do
      context "page layout" do
        before do
          login_for_system(user)
          create_list(:problem, 10, user: user)
          visit problems_path
        end

        it "confirm that the number of posts is displayed" do
          expect(page).to have_content "投稿 (#{user.problems.count})"
        end

        it "confirm that the post information is displayed" do
          Problem.take(10).each do |problem|
            expect(page).to have_content problem.description
          end
        end

        it "make sure the pagenation of the post is displayed" do
          expect(page).to have_css ".pagination"
        end
      end

      context "trouble posting feed" do
        before do
          login_for_system(user)
        end

        it "the Post link is displayed" do
         visit problems_path
         expect(page).to have_link "投稿する", href: new_problem_path
        end
      end
  end

  describe "problem post page" do
    before do
      login_for_system(user)
      visit new_problem_path
    end

    context "page layout" do
      it "the problempost string is present" do
        expect(page).to have_content '投稿'
      end

      it "the correct title is displayed" do
        expect(page).to have_title full_title('投稿')
      end

      it "appropriate label is displayed in the input part" do
        expect(page).to have_content '内容'
      end
    end

    context "problem post processing" do
        it "if you problem post with valid information, a flash of successful posting will be displayed" do
          fill_in "内容", with: "こんな悩みがあります。"
          click_button "投稿する"
          expect(page).to have_content "投稿が登録されました！"
        end

        it "when posting with invalid information, a flash of posting failure is displayed" do
          fill_in "内容", with: ""
          click_button "投稿する"
          expect(page).to have_content "内容を入力してください"
        end
    end
  end
end
