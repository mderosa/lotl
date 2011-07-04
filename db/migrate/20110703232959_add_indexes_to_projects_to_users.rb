class AddIndexesToProjectsToUsers < ActiveRecord::Migration
  def self.up
    add_index :projects_users, :user_id
    add_index :projects_users, :project_id
  end

  def self.down
    remove_index :projects_users, :user_id
    remove_index :projects_users, :project_id
  end
end
