require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "top page" do
    context "whole page" do
      before do
        visit root_path
      end

      it "confirm that the chillshare string exists" do
        expect(page).to have_content 'チルシェア'
      end

      it "make sure the correct title is displayed" do
        expect(page).to have_title full_title
      end
    end
  end
end
