
class StatisticsController < ApplicationController
  include StatisticsHelper

  def index
    now = Time.now.utc
    deliveries = Task.delivery_count_per_day(params[:project_id], now.to_date - 41, now.to_date)
    @deliveries_per_day = fill_date_gaps(deliveries, now.to_date - 41, now.to_date)
    logger.debug("data is: #{@deliveries_per_day}")
  end

end
