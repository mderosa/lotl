require 'spec_helper'

describe StatisticsController do

  def login_as(user)
    session[:user_id] = user.id
  end

  describe "GET 'index'" do
    before(:each) do
      @user = Factory(:user)
      login_as(@user)
    end

    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

end
