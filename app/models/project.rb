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
  has_many :tasks
  has_and_belongs_to_many :users
  default_scope :order => 'projects.name'

  attr_accessible :name, :repository

  validates :name, :presence => true,
                  :length => {:maximum => 255}

  validates :repository, :format => {:with => /^git@github.com:\w+\/\w+\.git$/, :allow_nil => true}

  def repository=(repo)
    return nil if repo.blank?
    return repo
  end

end
