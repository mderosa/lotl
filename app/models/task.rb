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
  validates :project_id, :numericality => {:only_integer => true},
                         :presence => true
  validates :progress, :inclusion => {:in => %w(proposed inProgress delivered)}
  validates :priority, :inclusion => {:in => [1,2,3], :allow_nil => true}

  def initialize(attributes = nil)
    super
    write_attribute :progess, 'proposed'
  end

  def progress=(next_state)
    current = read_attribute :progress
    if current == 'proposed'
      update_progress_from_proposed(next_state)
    elsif current == 'inProgress'
      update_progress_from_inProgress(next_state)
    elsif current == 'delivered'
      update_progress_from_delivered(next_state)
    else
      raise RuntimeError, 'Task.progress has an invalid state' if not current.nil?
    end
  end

  private

  def update_progress_from_delivered(next_state)
    if next_state == 'inProgress'
      write_attribute :progress, next_state
      write_attribute :work_finished_at, nil
    end
  end

  def update_progress_from_inProgress(next_state)
    if next_state == 'delivered'
      write_attribute :progress, next_state
      write_attribute(:work_finished_at, Time.now) if read_attribute(:work_finished_at).nil?
      write_attribute :delivered_at, Time.now
    end
  end

  def update_progress_from_proposed(next_state)
    if next_state == 'inProgress'
      write_attribute :progress, next_state
      write_attribute :work_started_at, Time.now
    elsif next_state == 'delivered'
      write_attribute :progress, next_state
      write_attribute(:work_finished_at, Time.now) if read_attribute(:work_finished_at).nil?
      write_attribute :delivered_at, Time.now
    end
  end

end


# error: a date was not set to a time, write_attribute(:work_finished_at, next_state) if read_attribute(:work_finished_at).nil? 
# error: forgot to add a , between key-vals in a map
