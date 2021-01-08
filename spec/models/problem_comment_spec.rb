require 'rails_helper'

RSpec.describe ProblemComment, type: :model do
  let!(:problem_comment) { create(:problem_comment) }

  context "validation" do
    it "must be in a valid state" do
      expect(problem_comment).to be_valid
    end

    it "must be invalid without user_id" do
      problem_comment = build(:problem_comment, user_id: nil)
      expect(problem_comment).not_to be_valid
    end

    it "if there is no problem_id, it is in an invalid state" do
      problem_comment = build(:problem_comment, problem_id: nil)
      expect(problem_comment).not_to be_valid
    end

    it "if there is no content, it is in an invalid state" do
      problem_comment = build(:problem_comment, content: nil)
      expect(problem_comment).not_to be_valid
    end

    it "the content must be 100 characters or less" do
      problem_comment = build(:problem_comment, content: "あ" * 101)
      problem_comment.valid?
      expect(problem_comment.errors[:content]).to include("は100文字以内で入力してください")
    end
  end
end
