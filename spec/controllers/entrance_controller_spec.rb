require 'spec_helper'

describe EntranceController do

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end
  end

  describe 'POST login' do

    it "should create a user with just a :email and :password which when queried for errors should pass" do
      u = User.new(:password => "justatest", :email => "justa test")
      u.errors.any?.should be_false
    end

    describe "with invalid parameters" do
      
      it "creates a new :user with a nil value and a :submitted_credentials that has one error message" do
        post :login, :email => "notindb@nowhere.com", :password => "yobabyyobaby"
        assigns(:user).should be_nil
        submitted = assigns(:submitted_credentials)
        submitted.email.should eq("notindb@nowhere.com")
        submitted.errors.length.should eq(1)
      end
      
      it "will populate a user obj but still reject when the password is incorrect" do
        post :login, :email => "marc@email.com", :password => "yobabyyobaby"
        assigns(:user).should_not be_nil
        submitted = assigns(:submitted_credentials)
        submitted.errors.length.should eq(1)
      end
      
    end

  end

end
