# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Task.delete_all
Project.delete_all
User.delete_all

user = User.create!(:password => "password", :email => "marc@email.com")
user.active = true
user.save

project1 = Project.new(:name => "Project1")
project1.users << user
project1.save()




