require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the StatisticsHelper. For example:
#
# describe StatisticsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe StatisticsHelper do
  
  before(:each) do
    @data = [{"delivered_at" => "2011-07-03", "count" => "3"}, {"delivered_at" => "2011-07-04", "count" => "7"}]
  end

  describe "data conversion to our control chart" do
    it "should have an xbarbar element equal to 5" do
      rslt = to_control_chart(@data)
      rslt[:xbarbar].should eq(5)
    end

    it "should have an xbarbar of nil when the data is empty" do
      rslt = to_control_chart([])
      rslt[:xbarbar].should be_nil
    end

    it "should not allow lcl to be less than zero" do
      rslt = to_control_chart(@data)
      rslt[:xbarbar].should eq(5)

      rslt[:labels][0].should  eq("2011-07-03")
      rslt[:subgroupavgs][0].should eq(3)
    end
    
    it "should fill in any gaps in the date sequence" do
      data = @data << {"delivered_at" => "2011-07-07", "count" => "5"}
      rslt = fill_date_gaps(data, Date.parse("2011-07-01"), Date.parse("2011-07-10"))
      rslt.length.should eq(10)
      rslt.each do |e|
        e["delivered_at"].should_not be_nil
      end
        
    end
    

  end

end
