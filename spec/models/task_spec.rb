require 'spec_helper'

describe Task do
  
  describe "validation requirements" do

    before(:each) do
      @params = {title: "atitle", specification: "this is required to do stuff", project_id: "1",
        delivers_user_functionality: "true", progress: "proposed", priority: nil, namespace: ""}
      @task = Task.new(@params)
    end

    it "title should not be blank" do
      @task.title = "  "
      @task.should_not be_valid
    end

    it "project id should be numeric and is required" do
      @task.project_id = nil
      @task.should_not be_valid
      @task.project_id = "dd34"
      @task.should_not be_valid
    end

    it "progress should be proposed | inProgress | delivered" do
      @task.progress = nil
      @task.should_not be_valid
    end
      
    it "priority should be one of nil | 1 | 2 | 3" do
      @task.priority = 5
      @task.should_not be_valid
      @task.priority = 0
      @task.should_not be_valid
      @task.priority = nil
      @task.should be_valid
    end
    
  end

end
