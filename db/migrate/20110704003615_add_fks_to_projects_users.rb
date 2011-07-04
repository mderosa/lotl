class AddFksToProjectsUsers < ActiveRecord::Migration
  def self.up
    execute <<-SQL1
ALTER TABLE projects_users
ADD CONSTRAINT fk_projects_users_users FOREIGN KEY (user_id) REFERENCES users (id)
    SQL1

    execute <<-SQL2
ALTER TABLE projects_users
ADD CONSTRAINT fk_projects_users_projects FOREIGN KEY (project_id) REFERENCES projects (id)
    SQL2
  end

  def self.down
    execute <<-SQL1
ALTER TABLE projects_users DROP CONSTRAINT fk_projects_users_users
    SQL1

    execute <<-SQL2
ALTER TABLE projects_users DROP CONSTRAINT fk_projects_users_projects
    SQL2
  end
end
