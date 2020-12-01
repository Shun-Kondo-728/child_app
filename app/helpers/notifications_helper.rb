module NotificationsHelper
  def notification_form(notification)
    @visiter = notification.visiter
    @comment = nil
    @visiter_comment = notification.comment_id
    case notification.action
    when 'follow'
      tag.a(notification.visiter.name, href: user_path(@visiter)) + 'があなたをフォローしました'
    when 'like'
      tag.a(notification.visiter.name, href: user_path(@visiter)) + 'が' + tag.a('あなたの投稿', href: post_path(notification.post_id)) + 'にいいねしました'
    when 'comment' then
      @comment = Comment.find_by(id: @visiter_comment)
      @comment_content =@comment.content
      @post_title =@comment.post.title
      tag.a(@visiter.name, href: user_path(@visiter)) + 'が' + tag.a("#{@post_title}", href: post_path(notification.post_id)) + 'にコメントしました'
    end
  end

  def unchecked_notifications
    @notifications=current_user.passive_notifications.where(checked: false)
  end
end
