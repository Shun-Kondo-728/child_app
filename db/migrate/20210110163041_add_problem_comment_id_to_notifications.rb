class AddProblemCommentIdToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :problem_comment_id, :integer
  end
end
