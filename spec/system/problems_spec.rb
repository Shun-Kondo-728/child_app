require 'rails_helper'

RSpec.describe "Problem posts", type: :system do
  let!(:user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }

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

  describe "problem post details page" do
    context "page layout" do
      before do
        login_for_system(user)
        visit problem_path(problem)
      end

      it "the correct title is displayed" do
        expect(page).to have_title full_title("悩み投稿")
      end

      it "problem post information is displayed" do
        expect(page).to have_content user.name
        expect(page).to have_content problem.description
      end
    end

    context "delete problem post", js: true do
        it "a flash of successful deletion is displayed" do
          login_for_system(user)
          visit problem_path(problem)
          within find('.change-post') do
            click_on '削除'
          end
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content '投稿が削除されました'
        end
    end
  end

  describe "problem post edit page" do
    before do
      login_for_system(user)
      visit problem_path(problem)
      click_link "編集"
    end

    context "page layout" do
      it "the correct title is displayed" do
        expect(page).to have_title full_title('投稿の編集')
      end

      it "appropriate label is displayed in the input part" do
        expect(page).to have_content '内容'
      end
    end

    context "problem post update process" do
        it "valid updates" do
          fill_in "内容", with: "編集：実は悩みがあります。"
          click_button "更新する"
          expect(page).to have_content "投稿が更新されました！"
          expect(problem.reload.description).to eq "編集：実は悩みがあります。"
        end

        it "invalid update" do
          fill_in "内容", with: ""
          click_button "更新する"
          expect(page).to have_content '内容を入力してください'
          expect(problem.reload.description).not_to eq ""
        end
    end

    context "post deletion process", js: true do
        it "a flash of successful deletion is displayed" do
          click_on '削除'
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content '投稿が削除されました'
        end
    end
  end
end
