class CreateProblemComments < ActiveRecord::Migration[5.2]
  def change
    create_table :problem_comments do |t|
      t.integer :problem_id
      t.integer :user_id
      t.text :content

      t.timestamps
    end
    add_index :problem_comments, :user_id
    add_index :problem_comments, :problem_id
  end
end
