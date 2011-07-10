class TasksController < ApplicationController
  before_filter :authorize, :only => [:index, :new, :edit, :create, :update, :destroy]
  
  # GET /tasks
  # GET /tasks.xml
  def index
    @project = Project.find(params[:project_id])
    @proposed_tasks = Task.where("progress = 'proposed' AND project_id = :project_id", params)
      .order("priority DESC").limit(15).offset(0)
    @inProgress_tasks = Task.where("progress = 'inProgress' AND project_id = :project_id", params)
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
  def create
    @task = Task.new(params[:task])
    @task.project_id = params[:project_id]

    respond_to do |format|
      if @task.save
        format.html { redirect_to(project_tasks_path(params[:project_id]), :notice => 'Task was successfully created.') }
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

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to(project_tasks_path(params[:project_id]), :notice => 'Task was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(project_tasks_path(params[:project_id])) }
      format.xml  { head :ok }
    end
  end

  private 

  def authorize
    p = Project.find(params[:project_id])
    if not p.users.include?(current_user)
      flash[:notice] = "access to resource denied"
      redirect_to home_path
    end
  end

end

# errors: forgot to add : before a map key
