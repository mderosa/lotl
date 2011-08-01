
class StatisticsController < ApplicationController
  include StatisticsHelper
  
  def index
    @chart_data = fetch_delivery_count_per_day(params[:project_id], delivery_count_time_range)
  end

  # delivery_count_time_range :: {:from => Date, :to => Date}
  # Returns up to 40 days of delivery counts if that amount of data exists for a project. This method
  # currently does not make allowances for weekends
  def delivery_count_time_range
    now = Time.now.utc
    first_delivery = Task.minimum("delivered_at") || now
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
    puts "expires at: #{expires_at}"
    puts "now: #{Time.new.utc}"
    data = cache.fetch "#{project_id}.delivery_count_per_day", :expires_in => (expires_at - Time.new.utc) do
      raw_delivery_data = Task.delivery_count_per_day(project_id, from, to)
      deliveries_by_day = fill_date_gaps(raw_delivery_data, from, to)
      to_control_chart(deliveries_by_day)
    end
  end

end
