
class StatisticsController < ApplicationController
  include StatisticsHelper
  
  def index
    project_id = params[:project_id]
    @chart_data = fetch_delivery_count_per_day(project_id, delivery_count_time_range(project_id))
  end

  # delivery_count_time_range :: {:from => Date, :to => Date}
  # Returns up to 40 days of delivery counts if that amount of data exists for a project. This method
  # currently does not make allowances for weekends
  def delivery_count_time_range(project_id)
    now = Time.now.utc
    first_delivery = Task.where("project_id = ?", project_id).minimum("delivered_at") || now
    from = (now.to_date - 41) < first_delivery.to_date ? first_delivery.to_date : now.to_date - 41
    to = now.to_date - 1
    {:from => from, :to => to}
  end

  # fetch_delivery_count_per_day :: Int -> {:from => Date, :to => Date} ->
  #                                 {:xbarbar: Maybe Int, :xbarucl: Maybe Int,
  #                                  :xbarlcl: Maybe Int, :subgroupavgs: [Int]
  #                                  :labels: [String]}  
  # Fetch the delivery count per day trying to find the data in the cache first
  def fetch_delivery_count_per_day(project_id, 
                                   delivery_date_range, 
                                   expires_at = Time.new.utc.tomorrow.midnight)
    from = delivery_date_range[:from]
    to = delivery_date_range[:to]
    data = cache.fetch "#{project_id}.delivery_count_per_day", :expires_in => (expires_at - Time.new.utc) do
      raw_delivery_data = Task.delivery_count_per_day(project_id, from, to)
      deliveries_by_day = fill_date_gaps(raw_delivery_data, from, to)
      to_control_chart(deliveries_by_day)
    end
  end

  def cost_data
    Task.where("delivered_at is not null").order("delivered_at desc").limit(120)
  end

end

# error: forgot to add a where clause restricting min(delivered_at) to just project of interest
