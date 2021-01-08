class ProblemsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update]

  def index
    @problems = current_user.problems.all
    @problems = @problems.page(params[:page]).per(5)
    @problem = current_user.problems.new
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

  private

    def problem_params
      params.require(:problem).permit(:description)
    end

    def correct_user
      @problem = current_user.problems.find_by(id: params[:id])
      redirect_to root_url if @problem.nil?
    end
end
