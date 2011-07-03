class CreateProjectsUsersTable < ActiveRecord::Migration
  def self.up
    create_table :projects_users, :id => false do |t|
      t.integer :user_id, :null => false 
      t.integer :project_id, :null => false
    end
  end

  def self.down
    drop_table :projects_users
  end
end
