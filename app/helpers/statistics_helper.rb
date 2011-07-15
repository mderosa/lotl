require 'date'

module StatisticsHelper

  # to_control_chart :: [{"delivered_at" => String, "count" => Int}] -> {:xbarbar: Maybe Int, :xbarucl: Maybe Int,
  #                                                                      :xbarlcl: Maybe Int, :subgroupavgs: [Int]
  #                                                                      :labels: [String]}
  def to_control_chart(data)
    temp = {:total => 0, :xbarbar => nil, :xbarucl => nil, :xbarlcl => nil, :subgroupavgs => [], :labels => []}
    
    data.each do |d|
      temp[:total] += d["count"].to_i
      temp[:subgroupavgs] << d["count"].to_i
      temp[:labels] << d["delivered_at"]
    end
    if data.length > 0
      temp[:xbarbar] = ((temp[:total] * 1.0)/data.length).round(2)
      temp[:xbarucl] = (temp[:xbarbar] + 3 * temp[:xbarbar]).round(2)
      temp[:xbarlcl] = (temp[:xbarbar] - 3 * temp[:xbarbar]).round(2)
      if temp[:xbarlcl] < 0 
        temp[:xbarlcl] = 0
      end
    end
    return temp
  end

  # fill_date_gaps :: [{"delivered_at" => String, "count" => Int}] -> Date -> Date -> [{"delivered_at" => String, "count" => Int}]
  def fill_date_gaps(data, from, to)
    filled = []
    (from..to).each do |rng_date|
      db_date = data.first['delivered_at'] unless data.first.nil?
      if db_date.nil? or rng_date < Date.parse(db_date)
        filled << {"delivered_at" => rng_date.to_s, "count" => 0}
      elsif rng_date == Date.parse(db_date)
        filled << data.shift
      else
        raise RangeError, "we should never get to this point db_date: #{db_date}, rng_date: #{rng_date}"
      end
    end
    return filled
  end

end
