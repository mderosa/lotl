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
end
