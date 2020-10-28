class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @feed_items = current_user.feed.page(params[:page]).per(10)
    end
  end

  def help
  end
end
