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

  def show_current_project?
    not session[:project_name].nil?
  end

  def current_project
    session[:project_name]
  end

  def show_task_selections?(params)
    params[:controller] == "tasks" and params[:action] == "index"
  end

  def show_task_list_selection?(param)
    params[:controller] == "tasks"
  end

end
