class ApplicationController < ActionController::Base
  before_action :set_search
  include SessionsHelper

  def set_search
    if logged_in?
      @search_word = params[:q][:title_or_description_cont] if params[:q]
      @q = current_user.feed.page(params[:page]).per(10).ransack(params[:q])
      @feed_items = current_user.feed.page(params[:page]).per(10)
      @posts = @q.result(distinct: true)
    end
  end

  private

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end
end
