require 'rails_helper'

RSpec.describe Membership, type: :model do
  let!(:membership) { create(:membership) }

  it "the relationship is valid" do
    expect(membership).to be_valid
  end

  it "if talk_id is nil, the relationship is invalid" do
    membership.talk_id = nil
    expect(membership).not_to be_valid
  end

  it "if user_id is nil, the relationship is invalid" do
    membership.user_id = nil
    expect(membership).not_to be_valid
  end
end
