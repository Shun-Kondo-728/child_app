require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let!(:user) { create(:user) }

  context "If you check Keep logged in to log in" do
    before do
      login_remember(user)
    end

    it "Make sure remember_token is not empty" do
      expect(response.cookies['remember_token']).not_to eq nil
    end

    it "Make sure current_user points to the correct user even when the session is nil" do
      expect(current_user).to eq user
      expect(is_logged_in?).to be_truthy
    end
  end

  context "When logging in without checking Keep logged in" do
    it "Make sure remember_token is empty" do
      # クッキーを保存してログイン
      login_remember(user)
      delete logout_path
      # クッキーを保存せずにログイン
      post login_path, params: { session: { email: user.email,
                                            password: user.password,
                                            remember_me: '0' } }
      expect(response.cookies['remember_token']).to eq nil
    end
  end

  context "When logging out" do
    it "Make sure you log out only while logged in" do
      login_for_request(user)
      expect(response).to redirect_to root_path
      # ログアウトする
      delete logout_path
      expect(response).to redirect_to root_path
      expect(session[:user_id]).to eq nil
      # 2番目のウィンドウでログアウトする
      delete logout_path
      expect(response).to redirect_to root_path
      expect(session[:user_id]).to eq nil
    end
  end
end
