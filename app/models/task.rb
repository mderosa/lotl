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

  def self.delivery_count_per_day(project_id, from, to, user = nil)
    id = project_id.to_i
    if user.nil?
      sql = "SELECT date(delivered_at) as delivered_at, count(*)
FROM tasks
WHERE delivered_at is not null
AND project_id = #{id}
AND delivered_at >= '#{from}'::date
AND delivered_at <= '#{to}'::date + 1
GROUP BY date(delivered_at)
ORDER BY date(delivered_at)"
      Task.connection.select_all sql
    elsif
      sql = "SELECT date(t.delivered_at) as delivered_at, count(*)
FROM tasks t
INNER JOIN tasks_users tu ON tu.task_id = t.id 
WHERE t.delivered_at is not null
AND t.project_id = #{id}
AND t.delivered_at >= '#{from}'::date
AND t.delivered_at <= '#{to}'::date + 1
AND tu.user_id = #{user.id}
GROUP BY date(t.delivered_at)
ORDER BY date(t.delivered_at)"
      Task.connection.select_all sql
    end
  end

  def add_collaborator(user)
    pos = (user.email =~ /@/) - 1
    user_name = user.email[0..pos]

    cs = []
    if not read_attribute(:collaborators).nil?
        cs = read_attribute(:collaborators).split(", ")
    end
    unless cs.include? user_name
      cs << user_name
      write_attribute(:collaborators, cs.join(", "))
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
      dt = Time.now
      write_attribute :work_started_at, dt
      write_attribute :work_finished_at, dt
      write_attribute :delivered_at, dt
    end
  end

end


# error: a date was not set to a time, write_attribute(:work_finished_at, next_state) if read_attribute(:work_finished_at).nil? 
# error: forgot to add a , between key-vals in a map
