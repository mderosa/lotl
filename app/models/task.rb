# == Schema Information
# Schema version: 20110703011409
#
# Table name: tasks
#
#  id                          :integer         not null, primary key
#  title                       :string(255)     not null
#  specification               :text
#  project_id                  :integer
#  delivers_user_functionality :boolean         not null
#  work_started_at             :datetime
#  work_finished_at            :datetime
#  delivered_at                :datetime
#  terminated_at               :datetime
#  progress                    :string(16)      default("proposed"), not null
#  priority                    :integer
#  namespace                   :string(255)
#  created_at                  :datetime
#  updated_at                  :datetime
#

class Task < ActiveRecord::Base
  belongs_to :project
  has_and_belongs_to_many :users

  attr_accessible :title, :specification, :project_id, :delivers_user_functionality,
                  :progress, :priority, :namespace

  validates :title, :presence => true
  validates :project_id, :numericality => {:only_integer => true}
  validates :progress, :inclusion => {:in => %w(proposed inProgress delivered)}
  validates :priority, :inclusion => {:in => [1,2,3], :allow_nil => true}
  
end
