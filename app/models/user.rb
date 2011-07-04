# == Schema Information
# Schema version: 20110703011409
#
# Table name: users
#
#  id         :integer         not null, primary key
#  password   :string(64)      not null
#  salt       :string(64)      not null
#  email      :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  has_and_belongs_to_many :projects
  has_and_belongs_to_many :tasks

  attr_accessible :password, :email, :salt

  validates :email, :presence => true,
                    :format => {:with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i}

end
