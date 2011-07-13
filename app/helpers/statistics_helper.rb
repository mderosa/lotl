require 'date'

module StatisticsHelper

  # takes a array of the form [{:delivered_at => d, :count => 3}] and transforms it to
  #                 	var xbardata = {
  #                    	"xbarbar": nil | number,
  #                     "xbarucl": nil | number,
  #                     "xbarlcl": nil | number,
  #                     "subgroupavgs": []
  #                     "labels": []
  #             	};
  def to_control_chart(data)
    temp = {:total => 0, :xbarbar => nil, :xbarucl => nil, :xbarlcl => nil, :subgroupavgs => [], :labels => []}
    
    data.each do |d|
      temp[:total] += d["count"].to_i
      temp[:subgroupavgs] << d["count"].to_i
      temp[:labels] << d["delivered_at"]
    end
    if data.length > 0
      temp[:xbarbar] = (temp[:total] * 1.0)/data.length
      temp[:xbarucl] = temp[:xbarbar] + 3 * temp[:xbarbar]
      temp[:xbarlcl] = temp[:xbarbar] - 3 * temp[:xbarbar]
      if temp[:xbarlcl] < 0 
        temp[:xbarlcl] = 0
      end
    end
    return temp
  end

  def fill_date_gaps(data, from, to)
    filled = []
    (from..to).each do |rng_date|
      db_date = data.first['delivered_at'] unless data.first.nil?
      if db_date.nil? or rng_date < Date.parse(db_date)
        filled << {:delivered_at => rng_date.to_s, :count => 0}
      elsif rng_date == Date.parse(db_date)
        filled << data.shift
      else
        raise RangeError, "we should never get to this point db_date: #{db_date}, rng_date: #{rng_date}"
      end
    end
    return filled
  end

end
