class AddIndexToTasksTable < ActiveRecord::Migration
  def self.up
    add_index :tasks, :project_id
  end

  def self.down
    remove_index :tasks, :project_id
  end
end
