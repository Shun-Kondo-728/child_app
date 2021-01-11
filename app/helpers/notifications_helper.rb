module NotificationsHelper
  def notification_form(notification)
    @visiter = notification.visiter
    @comment = nil
    @problem_comment = nil
    @visiter_comment = notification.comment_id
    @visiter_problem_comment = notification.problem_comment_id
    case notification.action
    when 'follow'
      tag.a(notification.visiter.name, href: user_path(@visiter)) + 'があなたをフォローしました'
    when 'like'
      tag.a(notification.visiter.name, href: user_path(@visiter)) + 'が' + tag.a('あなたの投稿', href: post_path(notification.post_id)) + 'にいいねしました'
    when 'comment' then
      @comment = Comment.find_by(id: @visiter_comment)
      @comment_content = @comment.content
      @post_title = @comment.post.title
      tag.a(@visiter.name, href: user_path(@visiter)) + 'が' + tag.a("#{@post_title}", href: post_path(notification.post_id)) + 'にコメントしました'
    when 'problem_comment' then
      @problem_comment = ProblemComment.find_by(id: @visiter_problem_comment)
      @problem_comment_content = @problem_comment.content
      @problem_description = @problem_comment.problem.description
      tag.a(@visiter.name, href: user_path(@visiter)) + 'が' + tag.a("#{@problem_description}", href: problem_path(notification.problem_id)) + 'にコメントしました'
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
