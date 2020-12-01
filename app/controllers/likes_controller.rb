class LikesController < ApplicationController
  before_action :logged_in_user

  def index
    @likes = current_user.likes
  end

  def create
    @post = Post.find(params[:post_id])
    @user = @post.user
    current_user.like(@post)
    @post.create_notification_like!(current_user)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    current_user.likes.find_by(post_id: @post.id).destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end
end
