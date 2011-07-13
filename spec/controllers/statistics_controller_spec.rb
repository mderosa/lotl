require 'spec_helper'

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

end
