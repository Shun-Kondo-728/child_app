class ProblemComment < ApplicationRecord
  belongs_to :problem
  has_many :notifications, dependent: :destroy
  validates :user_id, presence: true
  validates :problem_id, presence: true
  validates :content, presence: true, length: { maximum: 100 }
end
