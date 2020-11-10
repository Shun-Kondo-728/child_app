require 'rails_helper'

RSpec.describe "Memberships", type: :request do
  let!(:user) { create(:user) }
  let!(:talk) { create(:talk) }
  let!(:membership) { create(:membership, talk: talk) }

  context "register talks" do
    context "if you are logged in" do
    end

    context "if you are not logged in" do
      it "talks cannot be registered and redirect to the login page" do
        expect {
          post memberships_path params: { talk_id: talk.id,
                                          member_id: user.id }
        }.not_to change(Membership, :count)
        expect(response).to redirect_to login_path
      end

      it "memberships cannot be deleted and redirect to the login page" do
        expect {
          delete membership_path(membership)
        }.not_to change(Membership, :count)
      end
    end
  end
end
