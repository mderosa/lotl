require 'spec_helper'

describe ProjectsController do
  render_views

  # This should return the minimal set of attributes required to create a valid
  # Project. As you add validations to Project, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {name: "aproject"}
  end

  def login_as(u)
    session[:user_id] = u.id
  end

  let(:user) do
    User.find_by_email("marc@email.com")
  end

  let (:unauth_user) do
    User.find_by_email("hacker@lulz.com")
  end

  describe "GET index" do
    before(:each) do
      login_as user
    end

    it "assigns all projects as @projects" do
      project = Project.create! valid_attributes
      project.users << user

      get :index
      assigns(:projects).should include(project)
    end
  end

  describe "GET show" do
    before(:each) do
      login_as user
    end

    it "assigns the requested project as @project" do
      project = Project.create! valid_attributes
      get :show, :id => project.id.to_s
      assigns(:project).should eq(project)
    end
    
  end

  describe "GET new" do
    before(:each) do
      login_as user
    end

    it "assigns a new project as @project" do
      get :new
      assigns(:project).should be_a_new(Project)
    end
  end

  describe "GET edit" do
    before(:each) do
      login_as user
    end

    it "assigns the requested project as @project" do
      project = Project.new valid_attributes
      project.users << user
      project.save

      get :edit, :id => project.id.to_s
      assigns(:project).should eq(project)
    end

    describe "for unauthorized users" do
      it "should not allow access to the edit form" do
        project = Project.new valid_attributes
        project.users << user
        project.save 

        login_as(unauth_user)
        get :edit, :id => project.id.to_s
        assigns(:project).should eq(nil)
        response.should redirect_to(home_path)
      end
    end
  end

  describe "POST create" do
    before(:each) do
      login_as user
    end

    describe "with valid params" do
      it "creates a new Project" do
        expect {
          post :create, :project => valid_attributes
        }.to change(Project, :count).by(1)
      end

      it "assigns a newly created project as @project" do
        post :create, :project => valid_attributes
        assigns(:project).should be_a(Project)
        assigns(:project).should be_persisted
        assigns(:project).users.should include(user)
      end

      it "redirects to the created project" do
        post :create, :project => valid_attributes
        response.should redirect_to(projects_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved project as @project" do
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        post :create, :project => {}
        assigns(:project).should be_a_new(Project)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        post :create, :project => {}
        response.should redirect_to(projects_path)
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      login_as user
    end

    describe "with valid params" do
      it "updates the requested project" do
        project = Project.new valid_attributes
        project.users << user
        project.save
        # Assuming there are no other projects in the database, this
        # specifies that the Project created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Project.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => project.id, :project => {'these' => 'params'}
      end

      it "assigns the requested project as @project" do
        project = Project.new valid_attributes
        project.users << user
        project.save

        put :update, :id => project.id, :project => valid_attributes
        assigns(:project).should eq(project)
      end

      it "redirects to the project" do
        project = Project.new valid_attributes
        project.users << user
        project.save

        put :update, :id => project.id, :project => valid_attributes
        response.should redirect_to(projects_path)
      end
    end

    describe "with invalid params" do
      it "assigns the project as @project" do
        project = Project.new valid_attributes
        project.users << user
        project.save

        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        put :update, :id => project.id.to_s, :project => {}
        assigns(:project).should eq(project)
      end

      it "re-renders the 'edit' template" do
        project = Project.new valid_attributes
        project.users << user
        project.save
        # Trigger the behavior that occurs when invalid params are submitted
        Project.any_instance.stub(:save).and_return(false)
        put :update, :id => project.id.to_s, :project => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      login_as(user)
    end

    it "destroys the requested project" do
      project = Project.new valid_attributes
      project.users << user
      project.save

      expect {
        delete :destroy, :id => project.id.to_s
      }.to change(Project, :count).by(0)
    end

    it "redirects to the projects list" do
      project = Project.new valid_attributes
      project.users << user
      project.save
      
      delete :destroy, :id => project.id.to_s
      response.should redirect_to(projects_url)
    end
  end

end
