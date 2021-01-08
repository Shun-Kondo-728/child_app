class ProblemCommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @problem = Problem.find(params[:problem_id])
    @user = @problem.user
    @problem_comment = @problem.problem_comments.build(user_id: current_user.id, content: params[:problem_comment][:content])
    if !@problem.nil? && @problem_comment.save
      flash[:success] = "コメントを追加しました！"
    else
      flash[:danger] = "空のコメントは投稿できません。"
    end
    redirect_to request.referrer || root_url
  end

  def destroy
  end
end
