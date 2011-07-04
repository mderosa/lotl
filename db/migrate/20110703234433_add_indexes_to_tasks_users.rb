class AddIndexesToTasksUsers < ActiveRecord::Migration
  def self.up
    add_index :tasks_users, :task_id
    add_index :tasks_users, :user_id
  end

  def self.down
    remove_index :tasks_users, :task_id
    remove_index :tasks_users, :user_id
  end
end
