require 'rails_helper'

RSpec.describe "Users", type: :request do
  before do
    get signup_path
  end

  it "Returning a normal response" do
    expect(response).to be_success
    expect(response).to have_http_status "200"
  end
end
