class DropProjectsTasksTable < ActiveRecord::Migration
  def self.up
    drop_table :projects_tasks
  end

  def self.down
    create_table :projects_tasks, :id => false do |t|
      t.integer :task_id, :null => false 
      t.integer :project_id, :null => false
    end
  end
end
