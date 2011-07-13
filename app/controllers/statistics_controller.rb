class StatisticsController < ApplicationController

  def index
    @deliveries_per_day = Task.delivery_count_per_day params[:project_id]
    logger.debug("data is: #{@deliveries_per_day}")
  end

end
