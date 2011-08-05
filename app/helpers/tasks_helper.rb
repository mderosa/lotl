module TasksHelper

  # here are the valid situations that we can run into
  # status   start_dt   release_dt  deploy_dt   term_dt   cost
  # proposed                                              0
  # proposed                                    1/6       0

  # inprog   1/1                                          now-1
  # inprog   1/1                                1/6       5(6-1)
  # inprog   1/1        1/3                               3-1
  # inprog   1/1        1/3                     1/6       5(6-1)
  # inprog   1/1        1/5          1/4                  4-1 + 5(5-4)
  
  # deliv    1/1        1/3          1/4                  4-1
  # deliv    1/1        1/5          1/4                  4-1 + 5(5-4)
  def calc_cost(task, opts = {:unit => :hours})
    raise ArgumentException, "invalid unit specification" unless [:hours].include? opts[:unit]

    if task.progress == 'proposed'
      0
    elsif task.progress == 'inProgress'
      _calc_inProgress_cost task, opts
    elsif task.progress == 'delivered'
      _calc_delivered_cost task, opts
    else 
    end
  end

  # inprog   1/1                                          now-1
  # inprog   1/1                                1/6       5(6-1)
  # inprog   1/1        1/3                               now-1
  # inprog   1/1        1/3                     1/6       5(6-1)
  # inprog   1/1        1/5          1/4                  4-1 + 5(5-4)
  def _calc_inProgress_cost task, opts
    if task.terminated_at
      _to_hours(5 * (task.terminated_at - task.work_started_at), opts)
    elsif task.delivered_at.nil?
      _to_hours(Time.now - task.work_started_at, opts) 
    else
      _to_hours(task.delivered_at - task.work_started_at + 5 * (task.work_finished_at - task.delivered_at), opts)
    end
  end

  # deliv    1/1        1/3          1/4                  4-1
  # deliv    1/1        1/5          1/4                  4-1 + 5(5-4)
  def _calc_delivered_cost task, opts
    if task.work_finished_at <= task.delivered_at
      _to_hours(task.delivered_at - task.work_started_at, opts)
    else
      _to_hours(task.delivered_at - task.work_started_at + 5 * (task.work_finished_at - task.delivered_at), opts)
    end
  end

  def _to_hours(seconds, opts)
    rslt = 0
    if opts[:unit] == :hours
       rslt = (seconds/(60 * 60 ))
    end
    rslt
  end

  def priority_image(threshold, task)
    if task.priority.nil? || task.priority < threshold
      "star-off.gif"
    else 
      "star-on.gif"
    end
  end

  def user_functionality_display(uf)
    uf == true ? 'Y' : 'N'
  end

end
