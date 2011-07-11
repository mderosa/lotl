require 'spec_helper'

describe User do

  describe "validation requirements" do
    
    before(:each) do
      @params = {:password => "password", :email => "marc.derosa@gmail.com", :password_confirmation => "password"}
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
      User.create!(@params)
      @user.should_not be_valid
    end

    it "comparison of unique email addresses should be case insensitive" do
      User.create!(@params)
      @user.email = "Marc@email.com"
      @user.should_not be_valid
    end

  end

  describe "password processing" do

    before(:each) do
      @params = {:password => "apassword", :password_confirmation => "apassword", :email => "aDude@dudemail.com"}
    end
    
    it "should populate the user object with a encryped password and a salt value" do
      u = User.create!(@params)
      u.password.length.should eq(64)
      u.salt.length.should eq(64)
    end

    it "should invalidate passwords that dont agree with their confirmation" do
      u = User.new(@params.merge(:password_confirmation => "ddkdkdkkdkd"))
      u.should_not be_valid
    end

    it "should require a user password" do
      u = User.new(@params.merge(:password => "dan", :password_confirmation => "dan"))
      u.should_not be_valid
    end
    
    it "should validate as true when we test the actual users password against its encrypted version" do
      u = User.create!(@params)
      actual = u.is_users_password?("apassword")
      actual.should be_true

      actual = u.is_users_password?("badtry")
      actual.should be_false
    end
  end

  describe "projects ordering" do
    before(:each) do
      @user = Factory(:user)
      @p1 = Factory(:project, :name => "Gamma", :users => [@user])
      @p2 = Factory(:project, :name => "Alpha", :users => [@user])
      @p3 = Factory(:project, :name => "Delta", :users => [@user])
    end

    it "should be by alphabetical order" do
      @user.projects.should == [@p2, @p3, @p1]
    end
  end

end

# error: typed is_users_password instead of is_users_password?
