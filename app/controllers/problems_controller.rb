class ProblemsController < ApplicationController
  before_action :logged_in_user

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

  private

    def problem_params
      params.require(:problem).permit(:description)
    end
end
