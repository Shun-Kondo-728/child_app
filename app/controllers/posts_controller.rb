class PostsController < ApplicationController
  before_action :logged_in_user

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "投稿されました！"
      redirect_to post_path(@post)
    else
      render 'posts/new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = "投稿が更新されました！"
      redirect_to @post
    else
      render 'edit'
    end
  end

  private

    def post_params
      params.require(:post).permit(:title, :description, :recommended)
    end
end
