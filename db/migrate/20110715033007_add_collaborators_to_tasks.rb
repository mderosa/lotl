class AddCollaboratorsToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :collaborators, :string
  end

  def self.down
    remove_column :tasks, :collaborators
  end
end
