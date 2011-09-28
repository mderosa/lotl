class ProjectsController < ApplicationController
  before_filter :authorize, :only => [:edit, :update, :destroy]

  # Here we get the prjects and the most recent task activity from that 
  # project. The definition of the recent task activity is At:T E 
  # t1.modified_at > t2.modified_at & n <= 3
  def index
    @projects = current_user.projects
    @project_tasks = recently_active_tasks(@projects)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])
    set_current_project

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    set_current_project
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    @project.users << current_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to(projects_path) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { 
          flash[:error] = @project.errors.full_messages[0] if not @project.valid?
          redirect_to(projects_path)
        }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(projects_path, :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end

  rescue ActiveRecord::StaleObjectError
    flash[:error] = t "flash.msg.project-stale-object"
    redirect_to(projects_path)
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    # @project = Project.find(params[:id])
    # @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

  private
  
  # recently_active_tasks :: [{project -> [task]}]
  def recently_active_tasks(ps)
    temp = {}
    ps.each do |p|
      ts = Task.where("project_id = ?", p.id).order("updated_at DESC").limit(3)
      temp[p] = ts
    end
    return temp
  end

  def authorize
    p = Project.find(params[:id])
    if not p.users.include?(current_user)
      flash[:notice] = t("flash.msg.access-denied")
      redirect_to home_path
    end
  end

  def set_current_project
    session[:project_name] = @project.name
  end

end

# error: missed a 'end' when copying code into this file
