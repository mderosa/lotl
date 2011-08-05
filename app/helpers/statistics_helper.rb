require 'date'

module StatisticsHelper

  # to_counts_control_chart :: [{"delivered_at" => String, "count" => Int}] -> {:xbarbar: Maybe Int, :xbarucl: Maybe Int,
  #                                                                      :xbarlcl: Maybe Int, :subgroupavgs: [Int]
  #                                                                      :labels: [String]}
  def to_counts_control_chart(data)
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
  # fills in any date gaps in data over the range from - to inclusive
  def fill_date_gaps(data, from, to)
    filled = []
    (from..to).each do |rng_date|
      db_date = data.first['delivered_at'] unless data.first.nil?
      if gap_in_db_dates? db_date, rng_date
        if is_weekday? rng_date
          filled << {"delivered_at" => rng_date.to_s, "count" => 0}
        end
      elsif rng_date == Date.parse(db_date)
        filled << data.shift
      else
        raise RangeError, "we should never get to this point db_date: #{db_date}, rng_date: #{rng_date}"
      end
    end
    return filled
  end

  def gap_in_db_dates?(db_date, rng_date)
    (db_date.nil? or rng_date < Date.parse(db_date))
  end

  def is_weekday?(rng_date)
    rng_date.cwday <= 5
  end

  def c4_factor(subgroup_size)
    raise ArgumentError, "the c4 factor only accepts numeric arguments greater than zero" unless subgroup_size.is_a? Numeric and subgroup_size > 1
    a = Math.sqrt(2.0/(subgroup_size - 1))
    b = (1.0 * subgroup_size / 2) - 1
    c = (1.0 * (subgroup_size - 1) / 2) - 1
    return a * fractional_factorial(b) / fractional_factorial(c)
  end

  def fractional_factorial(x)
    raise ArgumentError, "fractional factorial only accepts numeric arguments" if not x.is_a? Numeric
    raise ArgumentError, "fractional factorial only accepts half integer arguments, greater than 0" if x < 0.5 or (x % 0.5 != 0)
    Math.gamma (x + 1)
  end

  # xbar_average [(n1, n2, ...nN)] -> Double
  def xbar_average(gs, subgroup_size)
    raise ArgumentError, "the subgroups must be an array" unless gs.is_a? Array
    raise ArgumentError, "the subgroup size must be an integer greater than 0" unless subgroup_size.is_a? Integer and subgroup_size > 0
    return nil if gs.empty? or (gs.size == 1 and gs.first.size < subgroup_size)

    item_total = 0
    item_count = 0
    gs.each do |g|
      if g.size == subgroup_size
        item_total += g.sum
        item_count += subgroup_size
      elsif g.size != subgroup_size and not (g.equal? gs.last)
        raise ArgumentError, "incorrect group size discovered out size of sequence tail"
      end
    end
    item_total/item_count
  end

  def std_deviation(ds)
    avg = ds.sum / ds.size
    ss = ds.map do |x| (x - avg) ** 2 end
    return Math.sqrt( ss.sum / (ss.size - 1))
  end

  def xbar_average_std_deviation(gs, subgroup_size)
    return nil if gs.empty? or gs.first.size < subgroup_size

    ds = []
    gs.each do |g|
      if g.size == subgroup_size
        ds << std_deviation(g)
      end
    end
    ds.sum / ds.size
  end

  def control_limit(x_barbar, s_bar, subgroup_size)
    temp = (3 * s_bar) / (c4_factor(subgroup_size) * Math.sqrt(subgroup_size))
    yield x_barbar, temp
  end

  def xbar_ucl(x_barbar, s_bar, subgroup_size)
    control_limit x_barbar, s_bar, subgroup_size do |x, y|
      x + y
    end
  end

  def xbar_lcl(x_barbar, s_bar, subgroup_size)
    control_limit x_barbar, s_bar, subgroup_size do |x, y|
      x - y
    end
  end

  # subgroup_averages :: [(n1,n2...nN)] -> [Double]
  def subgroup_averages ds, subgroup_size
    temp = []
    ds.each do |d|
      if d.size == subgroup_size
        temp << d.sum/d.size
      end
    end
    temp
  end

  # to_xbar_control_chart :: [Double] -> Integer  -> {:xbarbar: Maybe Double, :xbarucl: Maybe Double,
  #                                                    :xbarlcl: Maybe Double, :subgroupavgs: [Double]}
  def to_xbar_control_chart data, subgroup_size
    ds = subgroup data, subgroup_size
    temp = {}
    temp[:xbarbar] = xbar_average ds, subgroup_size
    sbar = xbar_average_std_deviation ds, subgroup_size
    temp[:xbarucl] = xbar_ucl temp[:xbarbar], s_bar, subgroup_size
    temp[:xbarlcl] = xbar_lcl temp[:xbarbar], s_bar, subgroup_size
    temp[:subgroupavgs] = subgroup_averages ds, subgroup_size
  end

  def subgroup(ls, subgroup_size)
    return [] if ls.empty? 
    temp = [[]]
    ls.each do |l|
      last = temp.last
      if last.size == subgroup_size
        last = []
        temp << last
      end
      last << l
    end
    temp
  end

end
