require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let!(:other_user) { create(:user) }

  context "Validation" do
    it "Must be valid if you have a name and email address" do
      expect(user).to be_valid
    end

    it "Must be invalid without name" do
      user = build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include("を入力してください")
    end

    it "The name must be 25 characters or less" do
      user = build(:user, name: "a" * 26)
      user.valid?
      expect(user.errors[:name]).to include("は25文字以内で入力してください")
    end

    it "If there is no email address, it is invalid" do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    it "Email address must be within 255 characters" do
      user = build(:user, email: "#{"a" * 244}@example.com")
      user.valid?
      expect(user.errors[:email]).to include("は255文字以内で入力してください")
    end

    it "
    If the email address is duplicated, it must be invalid" do
      other_user = build(:user, email: user.email)
      other_user.valid?
      expect(other_user.errors[:email]).to include("はすでに存在します")
    end

    it "Email addresses must be saved in lowercase" do
      email = "ExamPle@example.com"
      user = create(:user, email: email)
      expect(user.email).to eq email.downcase
    end

    it "Must be invalid without password" do
      user = build(:user, password: nil, password_confirmation: nil)
      user.valid?
      expect(user.errors[:password]).to include("を入力してください")
    end

    it "Password must be at least 6 characters" do
      user = build(:user, password: "a" * 6, password_confirmation: "a" * 6)
      user.valid?
      expect(user).to be_valid
    end
  end

  context "authenticated?method" do
    it "Return false if the digest does not exist" do
      expect(user.authenticated?('')).to eq false
    end
  end

  context "follow function" do
    it "follow and unfollow work properly" do
      expect(user.following?(other_user)).to be_falsey
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be_falsey
    end
  end
end
