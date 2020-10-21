require "rails_helper"

RSpec.describe "Profile page", type: :request do
  let!(:user) { create(:user) }

  it "The response is displayed normally" do
    login_for_request(user)
    get user_path(user)
    expect(response).to render_template('users/show')
  end
end
