class TasksController < ApplicationController
  before_filter :authorize, :only => [:index, :new, :edit, :create, :update, :destroy]
  
  # GET /tasks
  # GET /tasks.xml
  def index
    @project = Project.find(params[:project_id])
    set_current_project 

    @proposed_tasks = Task.where("progress = 'proposed' AND project_id = :project_id", params)
      .order("COALESCE(priority, 0) DESC").limit(15).offset(0)
    @inProgress_tasks = Task.where("progress = 'inProgress' AND project_id = :project_id AND terminated_at is NULL", params)
      .order("work_started_at DESC").limit(15).offset(0)
    @delivered_tasks = Task.where("progress = 'delivered' AND project_id = :project_id", params)
      .order("delivered_at DESC").limit(15).offset(0)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.xml
  # Im adding the collaborator here but I dont add it to the tasks_users table. The reason is that the tasks_users table is 
  # mainly to record people that are doing actual work on the project and people that might propose a task are not necessarily
  # going to actually do any work on the task
  def create
    @task = Task.new(params[:task])
    @task.project_id = params[:project_id]
    @task.add_collaborator current_user

    respond_to do |format|
      if @task.save
        format.html { 
          flash[:success] = t("flash.msg.task-created")
          redirect_to(project_tasks_path(params[:project_id])) 
        }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])

    @task.add_collaborator current_user
    respond_to do |format|
      if @task.update_attributes(params[:task])
        if not @task.users.exists?(current_user.id)
          @task.users << current_user
        end 
        format.html { 
          redirect_to(project_tasks_path(params[:project_id]))
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end

  rescue ActiveRecord::StaleObjectError
    flash[:error] = "The task was modified while you were editing it. Please try again"
    redirect_to(project_tasks_path(params[:project_id]))
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    if @task.progress == "proposed"
      @task.destroy
    elsif @task.progress = "inProgress"
      @task.terminated_at = Time.new
      @task.save
    else 
      raise RuntimeError, 'Task.progress has an invalid state'
    end

    respond_to do |format|
      format.html { redirect_to(project_tasks_path(params[:project_id])) }
      format.xml  { head :ok }
    end
  end

  private 

  def authorize
    p = Project.find(params[:project_id])
    if not p.users.include?(current_user)
      flash[:notice] = t("flash.msg.access-denied")
      redirect_to home_path
    end
  end

  def set_current_project
    session[:project_name] = @project.name
  end

end

# error: forgot to add : before a map key
# error: moved add_collaborator after a save command. There were no futher save commnands so setting collaborators didnt happen 
# error: sql query did not restrict the inProgess list to elements with termination data not NULL
