# == Schema Information
# Schema version: 20110703011409
#
# Table name: projects
#
#  id         :integer         not null, primary key
#  name       :string(255)     not null
#  repository :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Project < ActiveRecord::Base
end
