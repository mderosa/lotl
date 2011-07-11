require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the DudesHelper. For example:
#
# describe DudesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe TasksHelper do

  describe "the cost calculation" do
    
    before(:each) do
      @params = {:progress => "proposed"}
    end

    it "should return zero for any task in 'proposed' status" do
      task = Task.new(@params)
      task.terminated_at = Time.utc(2000, 1, 6)
      cost = helper.calc_cost(task)
      cost.should eq(0)
    end
    
    it ", for a normally delivered task, should calculate hours to deploy divided by 24" do
      task = Task.new()
      task.progress = 'delivered'
      task.work_started_at = Time.utc(2000, 1, 1, 1, 24)
      task.work_finished_at = Time.utc(2000, 1, 3, 1, 33)
      task.delivered_at = Time.utc(2000, 1, 4, 5, 21)
      cost = helper.calc_cost(task)
      cost.should eq(75)
    end

    it ", for a reworked, delivered task, should return the elapsed days with an additional penalty" do
      task = Task.new
      task.progress = 'delivered'
      task.work_started_at = Time.utc(2000, 1, 1, 1, 24)
      task.work_finished_at = Time.utc(2000, 1, 5, 1, 33)
      task.delivered_at = Time.utc(2000, 1, 4, 5, 21)
      cost = helper.calc_cost(task)
      cost.should eq(176)
    end

    it "should return a straight penalty calculation for inProgress tasks with a termination date" do
      task = Task.new
      task.progress = 'inProgress'
      task.work_started_at = Time.utc(2000, 1, 1, 1, 24)
      task.work_finished_at = Time.utc(2000, 1, 3, 1, 33)
      task.terminated_at = Time.utc(2000, 1, 6 , 5, 21)
      cost = helper.calc_cost(task)
      cost.should eq(619)
    end

    it "should return a standard days elapsed calculation when delivered_at is null and terminated_at is null" do
      task = Task.new
      task.progress = 'inProgress'
      task.work_started_at = Time.utc(2001, 1, 1, 1, 24)
      task.delivered_at.should be_nil

      cost = helper.calc_cost(task)
      cost.should_not be_nil
      cost.should > 100      
    end

    it "should return elapsed days with penalty if the task is inProgress and being reworked" do
      task = Task.new
      task.progress = 'inProgress'
      task.work_started_at = Time.utc(2000, 1, 1, 1, 24)
      task.work_finished_at = Time.utc(2000, 1, 5, 5, 22)
      task.delivered_at = Time.utc(2000, 1, 4, 5, 21)

      cost = helper.calc_cost(task)
      cost.should_not be_nil
      cost.should eq(196)            
    end

  end

end

#error = wasnt aware that I restricted access to Task through the constructor
#error = forgot the switch parameters in unit test after a copy from another unit test
#error = forgot to customize all code in unit test after a copy from another unit test
