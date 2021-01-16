class ProblemsController < ApplicationController
  before_action :logged_in_user
  before_action :set_problem_search
  before_action :correct_user, only: [:edit, :update]

  def index
    @feed_problem_items = current_user.feed_problem.page(params[:page]).per(10)
  end

  def new
    @problem = Problem.new
  end

  def show
    @problem = Problem.find(params[:id])
    @problem_comment = ProblemComment.new
  end

  def create
    @problem = current_user.problems.build(problem_params)
    if @problem.save
      flash[:success] = "投稿が登録されました！"
      redirect_to problems_path
    else
      render 'problems/new'
    end
  end

  def edit
    @problem = Problem.find(params[:id])
  end

  def update
    @problem = Problem.find(params[:id])
    if @problem.update_attributes(problem_params)
      flash[:success] = "投稿が更新されました！"
      redirect_to @problem
    else
      render 'edit'
    end
  end

  def destroy
    @problem = Problem.find(params[:id])
    if current_user.admin? || current_user?(@problem.user)
      @problem.destroy
      flash[:success] = "投稿が削除されました"
      redirect_to request.referrer == user_url(@problem.user) ? user_url(@problem.user) : problems_path
    else
      flash[:danger] = "他人の投稿は削除できません"
      redirect_to root_url
    end
  end

  def problem_search
  end

  def set_problem_search
    if logged_in?
      @search = params[:q][:description_cont] if params[:q]
      @q = current_user.feed_problem.page(params[:page]).per(10).ransack(params[:q])
      @feed_problem_items = current_user.feed_problem.page(params[:page]).per(10)
      @problems = @q.result(distinct: true)
    end
  end

  private

    def problem_params
      params.require(:problem).permit(:description)
    end

    def correct_user
      @problem = current_user.problems.find_by(id: params[:id])
      redirect_to root_url if @problem.nil?
    end
end
