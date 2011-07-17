require 'spec_helper'

describe FeedbackController do

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    it "should be successful" do
      post 'create', :name => "marc", :email => "marc@email.com", :subject => "test", :comments => "good job"
      response.should redirect_to(home_path)
    end
  end

end
