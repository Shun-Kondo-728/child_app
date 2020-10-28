class PostsController < ApplicationController
  before_action :logged_in_user

  def new
    @post = Post.new
  end
end
