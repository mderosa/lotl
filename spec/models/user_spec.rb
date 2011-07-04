require 'spec_helper'

describe User do

  describe "validation requirements" do
    
    before(:each) do
      @params = {:password => "password", :email => "marc.derosa@gmail.com"}
      @user = User.new(@params)
    end

    it "a user should have a non null email" do
      @user.email = nil
      @user.email.should be_nil
      @user.should_not be_valid
    end

    it "a users email field must follow the standard email format" do
      @user.should be_valid
    end
      
    it "a invalid email format should not pass validation" do
      @user.email = "novalid"
      @user.should_not be_valid
    end

    it "a email with an incomplete domain specificaiton should fail validation" do
      @user.email = "ddkkd@test"
      @user.should_not be_valid
    end

    it "stored email addresses should be unique" do
      User.create!(@params.merge(:salt => "salt"))
      @user.should_not be_valid
    end

    it "comparison of unique email addresses should be case insensitive" do
      User.create!(@params.merge(:salt => "salt"))
      @user.email = "Marc@email.com"
      @user.should_not be_valid
    end

  end
end
