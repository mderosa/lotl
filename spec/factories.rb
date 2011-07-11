
Factory.define :user do |user|
  user.password    "password"
  user.email       "stardust@email.com"
end

Factory.define :project do |project|
  project.name   "the best project"
  project.association   :users
end


