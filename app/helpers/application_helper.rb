module ApplicationHelper
  
  def show_menu?(params)
    if params[:controller] == "entrance"
      false
    elsif params[:controller] == "projects" and params[:action] == "index"
      false
    elsif params[:controller] == "users" and params[:action] == "new"
      false
    elsif params[:controller] == "info" || params[:controller] == "feedback"
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
    !!(params[:controller] =~ /tasks|statistics/)
  end

end
