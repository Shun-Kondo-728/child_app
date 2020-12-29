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
  end
end
