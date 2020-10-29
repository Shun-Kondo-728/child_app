class PostsController < ApplicationController
  before_action :logged_in_user

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "投稿されました！"
      redirect_to root_url
    else
      render 'posts/new'
    end
  end

  private

    def post_params
      params.require(:post).permit(:title, :description, :recommended)
    end
end
