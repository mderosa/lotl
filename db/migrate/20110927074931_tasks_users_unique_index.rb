class TasksUsersUniqueIndex < ActiveRecord::Migration
  def self.up
    change_table :tasks_users do |t|
      t.index [:task_id, :user_id], :unique => true, :name => 'idx_unq_tasks_users'
    end
  end

  def self.down
    change_table :tasks_users do |t|
      t.remove_index :name => :idx_unq_tasks_users
    end
  end
end
