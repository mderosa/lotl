class AddFkToTasks < ActiveRecord::Migration
  def self.up
    execute <<-SQL
ALTER TABLE tasks 
ADD CONSTRAINT fk_tasks_projects FOREIGN KEY (project_id) REFERENCES projects (id)
    SQL
  end

  def self.down
    execute <<-SQL
ALTER TABLE tasks DROP CONSTRAINT fk_tasks_projects
    SQL
  end
end
