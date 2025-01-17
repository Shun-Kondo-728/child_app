require 'rails_helper'

RSpec.describe "Users", type: :request do
  before do
    get signup_path
  end

  it "Returning a normal response" do
    expect(response).to be_success
    expect(response).to have_http_status "200"
  end

  it "Register as a valid user" do
    expect {
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "password" } }
    }.to change(User, :count).by(1)
    redirect_to @user
    follow_redirect!
    expect(response).to render_template('users/show')
    expect(is_logged_in?).to be_truthy
  end

  it "Register as an invalid user" do
    expect {
      post users_path, params: { user: { name: "",
                                         email: "user@example.com",
                                         password: "password",
                                         password_confirmation: "pass" } }
    }.not_to change(User, :count)
    expect(is_logged_in?).not_to be_truthy
  end
end
