require 'rails_helper'

RSpec.describe Problem, type: :model do
  let!(:problem_yesterday) { create(:problem, :problem_yesterday) }
  let!(:problem_one_week_ago) { create(:problem, :problem_one_week_ago) }
  let!(:problem_one_month_ago) { create(:problem, :problem_one_month_ago) }
  let!(:problem) { create(:problem) }

  context "validation" do
    it "must be in a valid state" do
      expect(problem).to be_valid
    end

    it "the description must be 200 characters or less" do
      problem = build(:problem, description: "あ" * 201)
      problem.valid?
      expect(problem.errors[:description]).to include("は200文字以内で入力してください")
    end

    it "must be invalid without user_id" do
      problem = build(:problem, user_id: nil)
      problem.valid?
      expect(problem.errors[:user_id]).to include("を入力してください")
    end

    context "sort order" do
      it "the most recent post is the first post" do
        expect(problem).to eq Problem.first
      end
    end
  end
end
