class AddOptimisticLocks < ActiveRecord::Migration
  def self.up
    add_column :users, :lock_version, :integer, :default => 0
    add_column :projects, :lock_version, :integer, :default => 0
    add_column :tasks, :lock_version, :integer, :default => 0
    User.update_all(:lock_version => 0)
    Project.update_all(:lock_version => 0)
    Task.update_all(:lock_version => 0)
  end

  def self.down
    remove_column :users, :lock_version
    remove_column :projects, :lock_version
    remove_column :tasks, :lock_version
  end
end
