require 'spec_helper'

describe EntranceController do
  render_views

  describe "get activation_instructions" do
    it "should be successful" do
      get "activation_instructions"
      response.should be_success
    end

    it "should show a warning error message when a user object is available"
  end

  describe "get activation" do
    it "should send us back to the activation instruction page when bad info is submitted" do
      get :activate, :email => "notindb@notindb.com", :token => "bogus token"
      response.body.should match("LOTL")
    end
  end

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
        submitted.errors.length.should eq(2)
      end
      
    end

  end

end
