require 'rails_helper'

RSpec.describe Notification, type: :model do
  let!(:notification) { create(:notification) }

  it "the notification instance is valid" do
    expect(notification).to be_valid
  end

  it "if visiter_id is nil, it is invalid" do
    notification.visiter_id = nil
    expect(notification).not_to be_valid
  end

  it "if visited_id is nil, it is invalid" do
    notification.visited_id = nil
    expect(notification).not_to be_valid
  end

  it "if action is nil, it is invalid" do
    notification.action = nil
    expect(notification).not_to be_valid
  end

  it "if checked is nil, it is invalid" do
    notification.checked = nil
    expect(notification).not_to be_valid
  end
end
