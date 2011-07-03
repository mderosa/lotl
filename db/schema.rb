# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110703011409) do

  create_table "projects", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "repository"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects_tasks", :id => false, :force => true do |t|
    t.integer "task_id",    :null => false
    t.integer "project_id", :null => false
  end

  create_table "projects_users", :id => false, :force => true do |t|
    t.integer "user_id",    :null => false
    t.integer "project_id", :null => false
  end

  create_table "tasks", :force => true do |t|
    t.string   "title",                                                             :null => false
    t.text     "specification"
    t.integer  "project_id"
    t.boolean  "delivers_user_functionality",               :default => false,      :null => false
    t.datetime "work_started_at"
    t.datetime "work_finished_at"
    t.datetime "delivered_at"
    t.datetime "terminated_at"
    t.string   "progress",                    :limit => 16, :default => "proposed", :null => false
    t.integer  "priority"
    t.string   "namespace"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "password",   :limit => 64, :null => false
    t.string   "salt",       :limit => 64, :null => false
    t.string   "email",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
