class AddIndexToTaskDeliveredAt < ActiveRecord::Migration
  def self.up
    add_index :tasks, :delivered_at
  end

  def self.down
    remove_index :tasks, :delivered_at
  end
end
