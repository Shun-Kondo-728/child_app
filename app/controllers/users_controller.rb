class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy,
                                        :following, :followers,]
  before_action :correct_user,   only: [:edit, :update]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10)
    @currentUserMembership = Membership.where(user_id: current_user.id)
    @userMembership = Membership.where(user_id: @user.id)
    if @user.id == current_user.id
    else
      @currentUserMembership.each do |cu|
        @userMembership.each do |u|
          if cu.talk_id == u.talk_id
            @isTalk = true
            @talkId = cu.talk_id
          end
        end
      end
      if @isTalk
      else
        @talk = Talk.new
        @membership = Membership.new
      end
    end
  end

  def index
    @users = User.all.page(params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Chi-Shaへようこそ！"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params_update)
      flash[:success] = "プロフィールが更新されました！"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    # 管理者ユーザーの場合
    if current_user.admin?
      @user.destroy
      flash[:success] = "ユーザーの削除に成功しました"
      redirect_to users_url
    # 管理者ユーザーではないが、自分のアカウントの場合
    elsif current_user?(@user)
      @user.destroy
      flash[:success] = "自分のアカウントを削除しました"
      redirect_to root_url
    else
      flash[:danger] = "他人のアカウントは削除できません"
      redirect_to root_url
    end
  end

  def following
    @title = "フォロー中"
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page])
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    def user_params_update
      params.require(:user).permit(:name, :email, :introduction, :sex)
    end

    def correct_user
      @user = User.find(params[:id])
      if !current_user?(@user)
        flash[:danger] = "このページへはアクセスできません"
        redirect_to(root_url)
      end
    end
end
