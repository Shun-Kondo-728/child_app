class AddIndexToNotificationsComment < ActiveRecord::Migration[5.2]
  def change
    add_index :notifications, :problem_comment_id
  end
end
