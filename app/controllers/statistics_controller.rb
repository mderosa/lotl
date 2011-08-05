
class StatisticsController < ApplicationController
  include StatisticsHelper
  include TasksHelper
  
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
      to_counts_control_chart(deliveries_by_day)
    end
  end

  # cost_chart :: {:xbarbar: Maybe Double, :xbarucl: Maybe Double,
  #                :xbarlcl: Maybe Double, :subgroupavgs: [Double]}
  def cost_chart
    ts = Task.where("project_id = ? AND delivered_at is not null", params[:project_id]).order("delivered_at desc").limit(120)
    ln_cost = ts.reverse.map do |t|
      Math.log(calc_cost t)
    end
    log_data = to_xbar_control_chart ln_cost, 3
    convert_back_to_days log_data
  end

  def convert_back_to_days log_data
    {:xbarbar => log_data[:xbarbar].nil? ? nil : Math.exp(log_data[:xbarbar]), 
     :xbarucl => log_data[:xbarucl].nil? ? nil : Math.exp(log_data[:xbarucl]), 
     :xbarlcl => log_data[:xbarlcl].nil? ? nil : Math.exp(log_data[:xbarlcl]), 
     :subgroupavgs => log_data[:subgroupavgs].map do |a| Math.exp a end}
  end

end

# error: forgot to add a where clause restricting min(delivered_at) to just project of interest
# error: forgot to have a function return a value
