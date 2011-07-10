# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# run this file with 'bin/rake db:seed RAILS_ENV=test'

Task.delete_all
Project.delete_all
User.delete_all

user1 = User.create!(:password => "password", :email => "marc@email.com")
user1.active = true
user1.save
user2 = User.create!(:password => "password", :email => "hacker@lulz.com")
user2.active = true
user2.save

project1 = Project.new(:name => "Project1")
project1.users << user1
project1.save()




# error: didnt add an = sign between a variable and its assigning function
# error: changed a variable name - but not all instances of it
