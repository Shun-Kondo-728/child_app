class Post < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :description, length: { maximum: 200 }, presence: true
  validates :recommended,
            :numericality => {
              :only_interger => true,
              :greater_than_or_equal_to => 1,
              :less_than_or_equal_to => 5
            }
  validate  :picture_size

  def feed_comment(post_id)
    Comment.where("post_id = ?", post_id)
  end

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "：5MBより大きい画像はアップロードできません。")
      end
    end
end
