module ApplicationHelper
  
  def show_menu?(params)
    if params[:controller] == "entrance"
      false
    elsif params[:controller] == "projects" and params[:action] == "index"
      false
    else
      true
    end
  end

  def show_task_selections?(params)
    if params[:controller] == "tasks" and params[:action] == "index"
      true
    else
      false
    end
  end

end
