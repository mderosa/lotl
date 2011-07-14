
class StatisticsController < ApplicationController
  include StatisticsHelper

  def index
    now = Time.now.utc
    first_delivery = Task.minimum("delivered_at") || now
    from = (now.to_date - 41) < first_delivery.to_date ? first_delivery.to_date : now.to_date - 41

    raw_delivery_data = Task.delivery_count_per_day(params[:project_id], from, now.to_date)
    deliveries_by_day = fill_date_gaps(raw_delivery_data, from, now.to_date)
    @chart_data = to_control_chart(deliveries_by_day)
  end

end
