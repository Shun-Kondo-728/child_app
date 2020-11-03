require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:relationship) { create(:relationship) }

  it "the relationship is valid" do
    expect(relationship).to be_valid
  end

  it "if follower_id is nil, the relationship is invalid" do
    relationship.follower_id = nil
    expect(relationship).not_to be_valid
  end

  it "if followed_id is nil, the relationship is invalid" do
    relationship.followed_id = nil
    expect(relationship).not_to be_valid
  end
end
