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
require 'digest'

class User < ActiveRecord::Base
  before_save :encrypt_password

  has_and_belongs_to_many :projects
  has_and_belongs_to_many :tasks

  attr_accessible :password, :password_confirmation, :email

  validates :email, :presence => true,
                    :format => {:with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},
                    :uniqueness => {:case_sensitive => false}
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => {:within => 6..125}

  def is_users_password?(raw_pswd)
    salt = read_attribute(:salt)
    encr_pswd = read_attribute(:password)
    encr_pswd == Digest::SHA2.hexdigest(salt + raw_pswd)
  end

  private

  def encrypt_password
    if self.new_record?
      raw_pswd = read_attribute(:password)
      salt = Digest::SHA2.hexdigest(Time.now.to_s + raw_pswd)
      write_attribute(:salt, salt)

      encr_pswd = Digest::SHA2.hexdigest(salt + raw_pswd)
      write_attribute(:password, encr_pswd)
    end
  end

end

# error: forgot to add a comma between key/values in a literal map declaration
