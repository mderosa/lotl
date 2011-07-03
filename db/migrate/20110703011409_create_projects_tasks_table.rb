class CreateProjectsTasksTable < ActiveRecord::Migration
  def self.up
    create_table :projects_tasks, :id => false do |t|
      t.integer :task_id, :null => false 
      t.integer :project_id, :null => false
    end
  end

  def self.down
    drop_table :projects_tasks
  end
end
