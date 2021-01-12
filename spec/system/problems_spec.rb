require 'rails_helper'

RSpec.describe "Problem posts", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:problem) { create(:problem, user: user) }
  let!(:problem_comment) { create(:problem_comment, user_id: user.id, problem: problem) }

  describe "profile page" do
    context "prpblem feed", js: true do
      it "problem pagination should be displayed" do
      login_for_system(user)
      create_list(:problem, 20, user: user)
      visit problems_path
      expect(page).to have_content "ユーザーの悩み投稿 (#{user.problems.count})"
      expect(page).to have_css ".pagination"
      Problem.take(10).each do |d|
        expect(page).to have_link d.description
      end
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
          within find('.change-problem-post') do
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

    context "register & delete problem_comments" do
        it "successful registration & deletion of problem_comments for your problem" do
          login_for_system(user)
          visit problem_path(problem)
          fill_in "problem_comment_content", with: "そうなんですね。"
          click_button "コメント"
          within find("#comment-#{ProblemComment.last.id}") do
            expect(page).to have_selector 'span', text: user.name
            expect(page).to have_selector 'span', text: 'そうなんですね。'
          end
          expect(page).to have_content "コメントを追加しました！"
          click_link "削除", href: problem_comment_path(ProblemComment.last)
          expect(page).not_to have_selector 'span', text: 'そうなんですね。'
          expect(page).to have_content "コメントを削除しました"
        end

        it "there is no delete link in the problem_comment of another user's problem" do
          login_for_system(other_user)
          visit problem_path(problem)
          within find("#comment-#{problem_comment.id}") do
            expect(page).to have_selector 'span', text: user.name
            expect(page).to have_selector 'span', text: problem_comment.content
            expect(page).not_to have_link '削除', href: problem_path(problem)
          end
        end
    end
  end
end
