class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :title, :null => false
      t.text :specification
      t.integer :project_id
      t.boolean :delivers_user_functionality, :null => false, :default => false
      t.timestamp :work_started_at
      t.timestamp :work_finished_at
      t.timestamp :delivered_at
      t.timestamp :terminated_at
      t.string :progress, :null => false, :default => "proposed", :limit => 16
      t.integer :priority
      t.string :namespace

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
