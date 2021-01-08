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
    @problem_comment = ProblemComment.find(params[:id])
    @problem = @problem_comment.problem
    if current_user.id == @problem_comment.user_id
      @problem_comment.destroy
      flash[:success] = "コメントを削除しました"
    end
    redirect_to problem_url(@problem)
  end
end
