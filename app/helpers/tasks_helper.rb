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
  def calc_cost(task)
    if task.progress == 'proposed'
      0
    elsif task.progress == 'inProgress'
      _calc_inProgress_cost(task)
    elsif task.progress == 'delivered'
      _calc_delivered_cost(task)
    else 
    end
  end

  # inprog   1/1                                          now-1
  # inprog   1/1                                1/6       5(6-1)
  # inprog   1/1        1/3                               now-1
  # inprog   1/1        1/3                     1/6       5(6-1)
  # inprog   1/1        1/5          1/4                  4-1 + 5(5-4)
  def _calc_inProgress_cost(task)
    if task.terminated_at
      _to_days(5 * (task.terminated_at - task.work_started_at))
    elsif task.delivered_at.nil?
      _to_days(Time.now - task.work_started_at) 
    else
      _to_days(task.delivered_at - task.work_started_at + 5 * (task.work_finished_at - task.delivered_at))
    end
  end

  # deliv    1/1        1/3          1/4                  4-1
  # deliv    1/1        1/5          1/4                  4-1 + 5(5-4)
  def _calc_delivered_cost(task)
    if task.work_finished_at <= task.delivered_at
      _to_days(task.delivered_at - task.work_started_at)
    else
      _to_days(task.delivered_at - task.work_started_at + 5 * (task.work_finished_at - task.delivered_at))
    end
  end

  def _to_days(seconds)
    (seconds/(60 * 60 * 24)).truncate
  end

  def priority_images(task)

  end

end
