
class StatisticsController < ApplicationController
  include StatisticsHelper

  def index
    now = Time.now.utc
    first_delivery = Task.minimum("delivered_at") || now
    from = (now.to_date - 41) < first_delivery.to_date ? first_delivery.to_date : now.to_date - 41
    to = now.to_date - 1

    raw_delivery_data = Task.delivery_count_per_day(params[:project_id], from, to)
    deliveries_by_day = fill_date_gaps(raw_delivery_data, from, to)
    @chart_data = to_control_chart(deliveries_by_day)
  end

end
