require 'rails_helper'
require 'faker'

RSpec.describe Post, type: :model do
  let!(:post_yesterday) { create(:post, :yesterday) }
  let!(:post_one_week_ago) { create(:post, :one_week_ago) }
  let!(:post_one_month_ago) { create(:post, :one_month_ago) }
  let!(:post) { create(:post) }

  context "Validation" do
    it "Must be in a valid state" do
      expect(post).to be_valid
    end

    it "If there is no title, it is invalid" do
      post = build(:post, title: nil)
      post.valid?
      expect(post.errors[:title]).to include("を入力してください")
    end

    it "The title must be 30 characters or less" do
      post = build(:post, title: "あ" * 31)
      post.valid?
      expect(post.errors[:title]).to include("は30文字以内で入力してください")
    end

    it "The description must be 800 characters or less" do
      post = build(:post, description: "あ" * 801)
      post.valid?
      expect(post.errors[:description]).to include("は800文字以内で入力してください")
    end

    it "Must be invalid without user ID" do
      post = build(:post, user_id: nil)
      post.valid?
      expect(post.errors[:user_id]).to include("を入力してください")
    end

    it "If the recommendation level is not 1 or higher, it must be in an invalid state." do
      post = build(:post, recommended: 0)
      post.valid?
      expect(post.errors[:recommended]).to include("は1以上の値にしてください")
    end

    it "If the recommendation level is not 5 or less, it is in an invalid state" do
      post = build(:post, recommended: 6)
      post.valid?
      expect(post.errors[:recommended]).to include("は5以下の値にしてください")
    end
  end

  context "Sort order" do
    it "The most recent post is the first post" do
      expect(post).to eq Post.first
    end
  end
end
