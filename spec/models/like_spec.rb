require 'rails_helper'

RSpec.describe Like, type: :model do
  let!(:like) { create(:like) }

  it "the like instance is valid" do
    expect(like).to be_valid
  end

  it "invalid if user_id is nil" do
    like.user_id = nil
    expect(like).not_to be_valid
  end

  it "Invalid if post_id is nil" do
    like.post_id = nil
    expect(like).not_to be_valid
  end
end
