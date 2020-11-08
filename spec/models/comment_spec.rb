require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:comment) { create(:comment) }

  context "validation" do
    it "must be in a valid state" do
      expect(comment).to be_valid
    end

    it "must be invalid without user_id" do
      comment = build(:comment, user_id: nil)
      expect(comment).not_to be_valid
    end

    it "if there is no post_id, it is in an invalid state" do
      comment = build(:comment, post_id: nil)
      expect(comment).not_to be_valid
    end

    it "if there is no content, it is in an invalid state" do
      comment = build(:comment, content: nil)
      expect(comment).not_to be_valid
    end

    it "the content must be 50 characters or less" do
      comment = build(:comment, content: "あ" * 51)
      comment.valid?
      expect(comment.errors[:content]).to include("は50文字以内で入力してください")
    end
  end
end
