class AddProblemIdToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :problem_id, :integer
  end
end
