require "spec_helper"

describe TasksController do
  describe "routing" do

    it "routes to #index" do
      get("/projects/3/tasks").should route_to("tasks#index", :project_id => "3")
    end

    it "routes to #new" do
      get("/projects/3/tasks/new").should route_to("tasks#new", :project_id => "3")
    end

    it "routes to #show" do
      get("/projects/3/tasks/1").should route_to("tasks#show", :id => "1", :project_id => "3")
    end

    it "routes to #edit" do
      get("/projects/3/tasks/1/edit").should route_to("tasks#edit", :id => "1", :project_id => "3")
    end

    it "routes to #create" do
      post("/projects/3/tasks").should route_to("tasks#create", :project_id => "3")
    end

    it "routes to #update" do
      put("/projects/3/tasks/1").should route_to("tasks#update", :id => "1", :project_id => "3")
    end

    it "routes to #destroy" do
      delete("/projects/3/tasks/1").should route_to("tasks#destroy", :id => "1", :project_id => "3")
    end

  end
end
