class AddFksToTasksUsers < ActiveRecord::Migration
  def self.up
    execute <<-SQL1
ALTER TABLE tasks_users
ADD CONSTRAINT fk_tasks_users_users FOREIGN KEY (user_id) REFERENCES users (id)
    SQL1

    execute <<-SQL2
ALTER TABLE tasks_users
ADD CONSTRAINT fk_tasks_users_tasks FOREIGN KEY (task_id) REFERENCES tasks (id)
    SQL2
  end

  def self.down
    execute <<-SQL1
ALTER TABLE tasks_users DROP CONSTRAINT fk_tasks_users_users
    SQL1

    execute <<-SQL2
ALTER TABLE tasks_users DROP CONSTRAINT fk_tasks_users_tasks
    SQL2
  end
end
