class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :post, optional: true
  belongs_to :comment, optional: true
  belongs_to :problem, optional: true
  belongs_to :problem_comment, optional: true

  belongs_to :visiter, class_name: 'User', foreign_key: 'visiter_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true

  validates :visiter_id, presence: true
  validates :visited_id, presence: true
  validates :action, presence: true
  validates :checked, inclusion: { in: [true, false] }
end
