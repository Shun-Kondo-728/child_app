require 'rails_helper'

RSpec.describe Message, type: :model do
  let!(:message) { create(:message) }

  context "validation" do
    it "must be in a valid state" do
      expect(message).to be_valid
    end

    it "must be invalid without talk_id" do
      message = build(:message, talk_id: nil)
      expect(message).not_to be_valid
    end

    it "if there is no user_id, it is in an invalid state" do
      message = build(:message, user_id: nil)
      expect(message).not_to be_valid
    end

    it "if there is no content, it is in an invalid state" do
      message = build(:message, content: nil)
      expect(message).not_to be_valid
    end

   it "the content must be 140 characters or less" do
     message = build(:message, content: "あ" * 141)
     message.valid?
     expect(message.errors[:content]).to include("は140文字以内で入力してください")
   end
  end
end
