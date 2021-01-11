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
end
