require "rails_helper"

RSpec.describe "post edit", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:new_post) { create(:post, user: user) }
  let(:picture2_path) { File.join(Rails.root, 'spec/fixtures/test_post2.jpg') }
  let(:picture2) { Rack::Test::UploadedFile.new(picture2_path) }

  context "for authorized users" do
    it "the response is displayed normally" do
      get edit_post_path(new_post)
      login_for_request(user)
      expect(response).to redirect_to edit_post_path(new_post)
      patch post_path(new_post), params: { post: { title: "赤ちゃんが泣き止む曲",
                                                   description: "この曲が、一番オススメです！",
                                                   picture: picture2,
                                                   recommended: 4 } }
      redirect_to new_post
      follow_redirect!
      expect(response).to render_template('posts/show')
    end
  end

  context "for users who are not logged in" do
    it "redirect to login screen" do
      get edit_post_path(new_post)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
      patch post_path(new_post), params: { post: { title: "赤ちゃんが泣き止む曲",
                                                   description: "この曲が、一番オススメです！",
                                                   recommended: 4 } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end

  context "for users of different accounts" do
    it "redirect to home screen" do
      login_for_request(other_user)
      get edit_post_path(new_post)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
      patch post_path(new_post), params: { post: {  title: "赤ちゃんが泣き止む曲",
                                                    description: "この曲が、一番オススメです！",
                                                    recommended: 4 } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end
end
