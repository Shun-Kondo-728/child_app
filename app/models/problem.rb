class Problem < ApplicationRecord
    belongs_to :user
    has_many :problem_comments, dependent: :destroy
    has_many :notifications, dependent: :destroy
    default_scope -> { order(created_at: :desc) }
    validates :user_id, presence: true
    validates :description, presence: true, length: { maximum: 200 }

    def feed_comment(problem_id)
      ProblemComment.where("problem_id = ?", problem_id)
    end

    def create_notification_problem_comment!(current_user, problem_comment_id)
        temp_ids = ProblemComment.select(:user_id).where(problem_id: id).where.not(user_id: current_user.id).distinct
        temp_ids.each do |temp_id|
          save_notification_problem_comment!(current_user, problem_comment_id, temp_id['user_id'])
        end
        save_notification_problem_comment!(current_user, problem_comment_id, user_id) if temp_ids.blank?
    end

    def save_notification_problem_comment!(current_user, problem_comment_id, visited_id)
      notification = current_user.active_notifications.new(
        problem_id: id,
        problem_comment_id: problem_comment_id,
        visited_id: visited_id,
        action: 'problem_comment'
      )
      if notification.visiter_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
end
