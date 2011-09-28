require 'spec_helper'

describe TasksController do
  render_views

  # This should return the minimal set of attributes required to create a valid
  # Task. As you add validations to Task, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {title: "atitle"}
  end

  def login_as(user)
    session[:user_id] = user.id
  end

  let (:auth_user) do
    User.find_by_email("marc@email.com")
  end

  let(:unauth_user) do
    User.find_by_email("hacker@lulz.com")
  end

  before(:each) do
    project = Project.find_by_name("Project1")
    @def_task = Task.new(valid_attributes)
    @def_task.project = project
    @def_task.save
  end

  describe "GET index" do
    before(:each) do
      login_as(auth_user)
    end

    it "assigns the newly created task above to @proposed tasks" do
      get :index, :project_id => @def_task.project_id.to_s
      assigns(:proposed_tasks).should include(@def_task)
    end

    describe "for unauthorized users" do
      it "redirects users not belonging to a project back to the home page" do
        session[:user_id] = unauth_user.id
        get :index, :project_id => @def_task.project_id.to_s
        response.should redirect_to(home_path)
      end
    end
  end

  describe "GET show" do
    before(:each) do
      login_as auth_user
    end

    it "assigns the requested task as @task" do
      get :show, :id => @def_task.id.to_s, :project_id => @def_task.project_id.to_s
      assigns(:task).should eq(@def_task)
    end
  end

  describe "GET new" do
    before(:each) do
      login_as auth_user
    end

    it "assigns a new task as @task" do
      get :new, :project_id => @def_task.project_id.to_s
      assigns(:task).should be_a_new(Task)
    end

    describe "by unauthoized users" do
      it "redirects users who are not part of a project back to the home page" do
        session[:user_id] = unauth_user.id
        get :new, :project_id => @def_task.project_id.to_s
        response.should redirect_to(home_path)
      end
    end
  end

  describe "GET edit" do
    before(:each) do
      login_as(auth_user)
    end

    it "assigns the requested task as @task" do
      get :edit, :id => @def_task.id.to_s, :project_id => @def_task.project_id.to_s
      assigns(:task).should eq(@def_task)
    end

    describe "for unauthorized users" do
      it "redirects users who are not part of a project back to the home page" do
        session[:user_id] = unauth_user.id
        get :edit, :id => @def_task.id.to_s, :project_id => @def_task.project_id.to_s
        response.should redirect_to(home_path)
      end
    end
  end

  describe "POST create" do
    before(:each) do
      login_as(auth_user)
      @project = Factory(:project, :users => [auth_user])
    end
    
    describe "with valid params" do
      it "creates a new Task" do
        expect {
          post :create, :task => valid_attributes, :project_id => @project.id
        }.to change(Task, :count).by(1)
      end

      it "assigns a newly created task as @task" do
        post :create, :task => valid_attributes, :project_id => @project.id
        assigns(:task).should be_a(Task)
        assigns(:task).should be_persisted
        auth_user.email.should match(assigns(:task).collaborators)
      end

    #     it "redirects to the created task" do
    #       post :create, :task => valid_attributes
    #       response.should redirect_to(Task.last)
    #     end
    end

    #   describe "with invalid params" do
    #     it "assigns a newly created but unsaved task as @task" do
    #       # Trigger the behavior that occurs when invalid params are submitted
    #       Task.any_instance.stub(:save).and_return(false)
    #       post :create, :task => {}
    #       assigns(:task).should be_a_new(Task)
    #     end

    #     it "re-renders the 'new' template" do
    #       # Trigger the behavior that occurs when invalid params are submitted
    #       Task.any_instance.stub(:save).and_return(false)
    #       post :create, :task => {}
    #       response.should render_template("new")
    #     end
    #   end
  end

  describe "PUT update" do
    describe "with valid params" do
      before(:each) do
        login_as auth_user
      end

      # it "updates the requested task" do
      #   task = Task.create! valid_attributes
      #   # Assuming there are no other tasks in the database, this
      #   # specifies that the Task created on the previous line
      #   # receives the :update_attributes message with whatever params are
      #   # submitted in the request.
      #   Task.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
      #   put :update, :id => task.id, :task => {'these' => 'params'}
      # end

      it "assigns the requested task as @task" do
        put :update, :id => @def_task.id, :task => valid_attributes, :project_id => @def_task.project_id
        assigns(:task).should eq(@def_task)
        assigns(:task).collaborators.should_not be_nil
        auth_user.email.should match(assigns(:task).collaborators)
      end

      it "redirects to the task" do
        put :update, :id => @def_task.id, :task => valid_attributes, :project_id => @def_task.project_id
        response.should redirect_to(project_tasks_path(@def_task.project_id))
      end
    end

    describe "with invalid params" do
      before(:each) do
        login_as(auth_user)
      end

      it "assigns the task as @task" do
        # Trigger the behavior that occurs when invalid params are submitted
        Task.any_instance.stub(:save).and_return(false)
        put :update, :id => @def_task.id.to_s, :task => {}, :project_id => @def_task.project_id.to_s
        assigns(:task).should eq(@def_task)
      end

      it "re-renders the 'edit' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Task.any_instance.stub(:save).and_return(false)
        put :update, :id => @def_task.id.to_s, :task => {}, :project_id => @def_task.project_id
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      login_as(auth_user)
    end

    it "destroys the requested task" do
      expect {
        delete :destroy, :id => @def_task.id.to_s, :project_id => @def_task.project_id
      }.to change(Task, :count).by(-1)
    end

    it "does not destroy a task if it is already has the status 'inProgress'" do
      @def_task.progress = 'inProgress'
      @def_task.save
      expect {
        delete :destroy, :id => @def_task.id.to_s, :project_id => @def_task.project_id
      }.to change(Task, :count).by(0)
    end

    it "redirects to the tasks list" do
      delete :destroy, :id => @def_task.id.to_s, :project_id => @def_task.project_id
      response.should redirect_to(project_tasks_url(@def_task.project_id))
    end
  end

end


#error: forgot to add a comma in a literal map
#error: declared a map key but did not make the symbol a symbol by adding a : before it
