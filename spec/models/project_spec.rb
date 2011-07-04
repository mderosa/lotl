require 'spec_helper'

describe Project do

  describe "validation requirements" do
    
    before(:each) do
      @user = User.new(:password => "password", :email => "marc@email.com")
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

  end
end
