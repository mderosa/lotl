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
      rslt.length.should eq(7)
      rslt.each do |e|
        e["delivered_at"].should_not be_nil
      end
    end

    it "should fill in any gaps in the date sequence except weekends" do
      data = []
      rslt = fill_date_gaps(data, Date.parse("2011-07-22"), Date.parse("2011-07-25"))
      rslt.length.should eq(2)
    end

    it "should keep any weekend dates if they are in the original sequence" do
      data = [{"delivered_at" => "2011-07-23", "count" => "2"}]
      rslt = fill_date_gaps(data, Date.parse("2011-07-22"), Date.parse("2011-07-25"))
      rslt.length.should eq(3)
    end
  end

  describe "xbar chart" do

    describe "calculations of the c4 factor" do
      it "should not accept inputs less than 1" do
        expect {
          c4_factor 0
        }.to raise_exception(ArgumentError)
      end

      it "should return .9727 for an input of 10" do
        actual = c4_factor 10
        actual.should > 0.972
        actual.should < 0.973
      end
    end

    describe "calculations of fractional factorial" do
      it "should return 11.632 for an input of 3.5" do
        actual = fractional_factorial(3.5)
        actual.should < 11.632
        actual.should > 11.631
      end

      it "should only accept half fractions, n/2" do
        expect {
          fractional_factorial(4.2)
        }.to raise_exception(ArgumentError)
      end

      it "should only accept numbers > 0.5" do
        expect {
          fractional_factorial(0)
        }.to raise_exception(ArgumentError)
      end
    end

    describe "calculations of the xbar average" do
      it "should return nil when the data list is empty" do
        actual = xbar_average [], 3
        actual.should be_nil
      end

      it "should not accept arguments other than an array" do
        expect {
          xbar_average nil, 3
        }.to raise_exception(ArgumentError)
      end

      it "should return the average of all the data elements" do
        actual = xbar_average [[1,2,3]], 3
        actual.should eq(2)
      end
      
      it "should not average any incomple subgroups" do
        actual = xbar_average [[1,2,3], [1,2]], 3
        actual.should eq(2)
      end
      
      it "should only allow one incomplete subgroup in the final position 1" do
        expect {
          xbar_average [[1,2], [2,3]], 3
        }.to raise_exception(ArgumentError)
      end

      it "should only allow one incomplete subgroup in the final position 2" do
        expect {
          xbar_average [[1,2,3], [1,2], [1,2,3]]
        }.to raise_exception(ArgumentError)
      end
    end
      
    describe "calculation of xbar charts average standard deviation" do
      it "should return nil when the subgroup array is empty" do
        actual = xbar_average_std_deviation [], 3
        actual.should be_nil
      end

      it "should return nil when the subgroup array is less than the subgroup size" do
        actual = xbar_average_std_deviation [[1]], 3
        actual.should be_nil
      end
      
      it "should only calculate the avg std dev based on full subgroups" do
        actual = xbar_average_std_deviation [[1,1,1], [1,4]], 3
        actual.should eq(0)
      end
    end


    describe "calculation of upper control limit" do
      it "should return appoximately x_barbar + 3 + s_bar for large samples" do
        actual = xbar_ucl 5, 1, 100
        actual.should > 5.3
        actual.should < 5.4
      end
    end
  end

end
