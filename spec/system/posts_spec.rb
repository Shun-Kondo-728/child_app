require 'rails_helper'

RSpec.describe "Posts", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:new_post) { create(:post, :picture, user: user) }
  let!(:comment) { create(:comment, user_id: user.id, post: new_post) }

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
          find('#review_star', visible: false).set(5.0)
          attach_file "post[picture]", "#{Rails.root}/spec/fixtures/test_post.jpg"
          click_button "投稿する"
          expect(page).to have_content "投稿されました！"
        end

        it "when posting with invalid information, a flash of posting failure is displayed" do
          fill_in "post[title]", with: ""
          fill_in "説明", with: ""
          find('#review_star', visible: false).set(0)
          click_button "投稿する"
          expect(page).to have_content "タイトルを入力してください"
          expect(page).to have_content "説明を入力してください"
        end
    end
  end

  describe "post details page" do
    context "page layout" do
      before do
        login_for_system(user)
        visit post_path(new_post)
      end

      it "the correct title is displayed" do
        expect(page).to have_title full_title("#{new_post.title}")
      end

      it "post information is displayed" do
        expect(page).to have_content new_post.title
        expect(page).to have_content new_post.description
        find("#star-recommended-#{new_post.id}")
        expect(page).to have_link nil, href: post_path(new_post), class: 'post-picture'
      end
    end

    context "delete post", js: true do
        it "a flash of successful deletion is displayed" do
          login_for_system(user)
          visit post_path(new_post)
          within find('.change-post') do
            click_on '削除'
          end
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content '投稿が削除されました'
        end
    end
  end

  describe "post edit page" do
    before do
      login_for_system(user)
      visit post_path(new_post)
      click_link "編集"
    end

    context "page layout" do
      it "the correct title is displayed" do
        expect(page).to have_title full_title('投稿の編集')
      end

      it "appropriate label is displayed in the input part" do
        expect(page).to have_content 'タイトル'
        expect(page).to have_content '説明'
        expect(page).to have_content 'オススメ度'
      end
    end

    context "post update process" do
        it "valid updates" do
          fill_in "post[title]", with: "編集：赤ちゃんが泣き止むおもちゃ"
          fill_in "説明", with: "編集：このおもちゃを鳴らせば泣き止む！"
          attach_file "post[picture]", "#{Rails.root}/spec/fixtures/test_post2.jpg"
          fill_in "オススメ度", with: 4
          click_button "更新する"
          expect(page).to have_content "投稿が更新されました！"
          expect(new_post.reload.title).to eq "編集：赤ちゃんが泣き止むおもちゃ"
          expect(new_post.reload.description).to eq "編集：このおもちゃを鳴らせば泣き止む！"
          expect(new_post.reload.picture.url).to include "test_post2.jpg"
          expect(new_post.reload.recommended).to eq 4
        end

        it "invalid update" do
          fill_in "post[title]", with: ""
          click_button "更新する"
          expect(page).to have_content 'タイトルを入力してください'
          expect(new_post.reload.title).not_to eq ""
        end
    end

    context "post deletion process", js: true do
        it "a flash of successful deletion is displayed" do
          click_on '削除'
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content '投稿が削除されました'
        end
    end

    context "register & delete comments" do
      it "successful registration & deletion of comments for your post" do
        login_for_system(user)
        visit post_path(new_post)
        fill_in "comment_content", with: "このおもちゃは革命的"
        click_button "コメント"
        within find("#comment-#{Comment.last.id}") do
          expect(page).to have_selector 'span', text: user.name
          expect(page).to have_selector 'span', text: 'このおもちゃは革命的'
        end
        expect(page).to have_content "コメントを追加しました！"
        click_link "削除", href: comment_path(Comment.last)
        expect(page).not_to have_selector 'span', text: 'このおもちゃは革命的'
        expect(page).to have_content "コメントを削除しました"
      end

      it "there is no delete link in the comment of another user's post" do
        login_for_system(other_user)
        visit post_path(new_post)
        within find("#comment-#{comment.id}") do
          expect(page).to have_selector 'span', text: user.name
          expect(page).to have_selector 'span', text: comment.content
          expect(page).not_to have_link '削除', href: post_path(new_post)
        end
      end
    end
  end

  context "search function" do
    context "if you are logged in" do
      before do
        login_for_system(user)
        visit root_path
      end

      it "a search window is displayed on each page after login" do
        expect(page).to have_css 'form#post_search'
        visit posts_path
        expect(page).to have_css 'form#post_search'
      end

      it "the result corresponding to the search word is displayed from the feed" do
        create(:post, title: '赤ちゃんのオムツ', user: user)
        create(:post, title: '赤ちゃんのおもちゃ', user: other_user)
        create(:post, title: '育児用洗剤', user: user)
        create(:post, title: '育児用ミルク', user: other_user)

        fill_in 'q_title_or_description_cont', with: '赤ちゃん'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”赤ちゃん”の検索結果：1件"
        within find('.posts') do
          expect(page).to have_css 'li', count: 1
        end
        fill_in 'q_title_or_description_cont', with: '育児'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”育児”の検索結果：1件"
        within find('.posts') do
          expect(page).to have_css 'li', count: 1
        end

        user.follow(other_user)
        fill_in 'q_title_or_description_cont', with: '赤ちゃん'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”赤ちゃん”の検索結果：2件"
        within find('.posts') do
          expect(page).to have_css 'li', count: 2
        end
        fill_in 'q_title_or_description_cont', with: '育児'
        click_button '検索'
        expect(page).to have_css 'h3', text: "”育児”の検索結果：2件"
        within find('.posts') do
          expect(page).to have_css 'li', count: 2
        end

        create(:post, description: '赤ちゃんの泣き声', user: user)
          fill_in 'q_title_or_description_cont', with: '赤ちゃん'
          click_button '検索'
          expect(page).to have_css 'h3', text: "”赤ちゃん”の検索結果：3件"
          within find('.posts') do
            expect(page).to have_css 'li', count: 3
          end
      end

      it "if you press the search button without entering a search word, the post list will be displayed." do
        fill_in 'q_title_or_description_cont', with: ''
        click_button '検索'
        expect(page).to have_css 'h3', text: "投稿一覧"
        within find('.posts') do
          expect(page).to have_css 'li', count: Post.count
        end
      end
    end

    context "if you are not logged in" do
      it "the search window is not displayed" do
        visit root_path
        expect(page).not_to have_css 'form#post_search'
      end
    end
  end
end
