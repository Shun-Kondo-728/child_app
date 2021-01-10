class AddIndexToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_index :notifications, :problem_id
  end
end
