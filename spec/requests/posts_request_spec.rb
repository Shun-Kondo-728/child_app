require 'rails_helper'

RSpec.describe "Posts", type: :request do
    let!(:user) { create(:user) }
    let!(:new_post) { create(:post, user: user) }
    let(:picture_path) { File.join(Rails.root, 'spec/fixtures/test_post.jpg') }
    let(:picture) { Rack::Test::UploadedFile.new(picture_path) }

    context "for logged-in users" do
      before do
        get new_post_path
        login_for_request(user)
      end

      context "friendly forwarding" do
        it "the response is displayed normally" do
          expect(response).to redirect_to new_post_url
        end
      end

      it "being able to register with valid post data" do
        expect {
          post posts_path, params: { post: { title: "赤ちゃんが泣き止む曲",
                                             description: "この曲が、一番オススメです！",
                                             recommended: 4,
                                             picture: picture } }
        }.to change(Post, :count).by(1)
        follow_redirect!
        expect(response).to render_template('posts/show')
      end

      it "cannot be registered with invalid post data" do
        expect {
          post posts_path, params: { post: { title: "赤ちゃんが泣き止む曲",
                                             description: "",
                                             recommended: 4,
                                             picture: picture } }
        }.not_to change(Post, :count)
        expect(response).to render_template('posts/new')
      end
    end

    context "for users who are not logged in" do
      it "redirect to login screen" do
        get new_post_path
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end
end
