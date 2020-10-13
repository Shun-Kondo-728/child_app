require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "home page" do
    it "Returning a normal response" do
      get root_path
      expect(response).to be_success
      expect(response).to have_http_status "200"
    end
  end

  describe "help page" do
    it "Returning a normal response" do
      get help_path
      expect(response).to be_success
      expect(response).to have_http_status "200"
    end
  end
end
