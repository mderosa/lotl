require 'spec_helper'

describe Task do
  
  describe "validation requirements" do

    before(:each) do
      @params = {title: "atitle", specification: "this is required to do stuff", project_id: "1",
        delivers_user_functionality: "true",  priority: nil, namespace: ""}
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

    it "progress should be proposed | inProgress | delivered and can not be set to invalid values" do
      @task.progress = nil
      @task.should be_valid
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

  describe "task creation" do
    it "should form an object with the progress in proposed" do
      t = Task.new()
      t.progress.should eq('proposed')
    end
  end

  describe "progress transitions" do
    it "from proposed straight to delivered should set the work started / finished and delivered dates" do
      t = Task.new(:title => "test", :progress => "proposed")
      t.progress = "delivered"
      t.work_started_at.should_not be_nil
      t.work_finished_at.should_not be_nil
      t.delivered_at.should_not be_nil
    end

    it "from proposed to inProgress should set work_started_at" do
      t = Task.new()
      t.work_started_at.should be_nil
      
      t.progress = 'inProgress'
      t.work_started_at.should_not be_nil
    end

    it "from inProgess to delivered should set the delivered at date" do
      t = Task.new()
      t.progress = 'inProgress'
      t.work_finished_at = Time.now
      t.delivered_at.should be_nil

      t.progress = 'delivered'
      t.delivered_at.should_not be_nil
    end

    it "from inProgress to delivered should set work_finished_at, if not set" do
      t = Task.new()
      t.progress.should eq('proposed')

      t.progress = 'inProgress'

      t.progress.should eq('inProgress')
      t.delivered_at.should be_nil
      t.work_finished_at.should be_nil

      t.progress = 'delivered'
      t.work_finished_at.should_not be_nil
      t.delivered_at.should_not be_nil
    end

    it "from delivered to inProgress should clear the work_finished_at date" do
      t = Task.new
      t.progress = 'delivered'
      t.progress = 'inProgress'
      t.work_finished_at.should be_nil
    end

    it "we can not go from inProgress to proposed" do
      t = Task.new
      t.progress = 'inProgress'
      t.progress = 'proposed'
      t.progress.should eq('inProgress')
    end

  end

  describe "database operations" do
    it "should be able to query deliveries per day" do
      Task.should respond_to(:delivery_count_per_day)
    end

    it "should provide a delivery_count_per_day method which returns an array" do
      t = Time.now.utc.to_date
      rslt = Task.delivery_count_per_day(1, t -1, t)
      rslt.should be_instance_of Array
    end

  end

  describe "collaborators property" do 
    it "each user name added to the collaborators string should be unique" do
      t = Task.new
      u = User.new
      u.email = "msderosa@test.com"

      t.add_collaborator u
      t.collaborators.should eq("msderosa")
      t.add_collaborator u
      t.collaborators.should eq("msderosa")
    end

    it "should be able to contain the names of several users" do
      u1 = User.new
      u1.email = "one@number.com"
      u2 = User.new
      u2.email = "two@number.com"

      t = Task.new
      t.add_collaborator u1
      t.add_collaborator u2
      t.collaborators.should eq("one, two")
    end
  end

end

#error typed in .. between class and method call
#error typed t.progess missing an r in progress
#error typed rstl instead of rslt
