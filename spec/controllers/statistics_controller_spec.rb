require 'spec_helper'
require 'date'

describe StatisticsController do
  render_views

  def login_as(user)
    session[:user_id] = user.id
  end

  describe "GET 'index'" do
    before(:each) do
      @user = Factory(:user)
      login_as(@user)
    end

    it "should be successful" do
      project = Project.first
      get :index, :project_id => project.id
      response.should be_success
    end
  end

  describe "cache control" do
    it "should place task data in the cache" do
      project = Project.first
      controller = StatisticsController.new
      now = Time.new.utc

      controller.cache.delete "#{project.id}.delivery_count_per_day"
      controller.fetch_delivery_count_per_day(project.id,
                                              {:from => now.yesterday.to_date, 
                                               :to => now.to_date}, now + 4)
      controller.cache.read("#{project.id}.delivery_count_per_day").should_not be_nil
      sleep 5
      controller.cache.read("#{project.id}.delivery_count_per_day").should be_nil
    end
  end

  describe "convert back to days" do
    let(:controller) do
      StatisticsController.new
    end

    it "should handle nil values as nil" do
      empty_data = {:xbarbar => nil, :xbarucl => nil, :xbarlcl => nil, :subgroupavgs => []}
      controller.convert_back_to_days(empty_data).should eq(empty_data)
    end

    it "should convert log(cost) numbers back to cost data" do
      data = {:xbarbar => 0, :xbarucl => 0, :xbarlcl => 0, :subgroupavgs => [0,0]}
      expected = {:xbarbar => 1, :xbarucl => 1, :xbarlcl => 1, :subgroupavgs => [1,1]}
      controller.convert_back_to_days(data).should eq(expected)
    end
  end

end
