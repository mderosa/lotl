require 'spec_helper'

describe EntranceController do
  render_views

  describe "get activation_instructions" do
    it "should be successful" do
      get "activation_instructions"
      response.should be_success
    end

    # it "should show a warning error message when a user object is available" do
    #   post :activate, :email => "notindb@notindb.com", :token => "bogus token"
    #   response.should have_tag("div.error", nil)
    # end
    
  end

  describe "get activation" do
    it "should send us back to the activation instruction page when bad info is submitted" do
      get :activate, :email => "notindb@notindb.com", :token => "bogus token"
      response.body.should match("LOOP")
    end

    it "an actual user in the system should be activated, placed in session, and redirected" do 
      user = User.first
      get :activate, :email => user.email, :token => user.salt
      assigns(:current_user).should_not be_nil
      assigns(:current_user).active.should be_true
      flash[:success].should_not be_nil
      response.should redirect_to(projects_path)
    end
  end

  describe "GET 'home'" do
    before(:each) do
      request.env["HTTPS"] = "on"
    end

    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should not show the site menu" do
      get "home"
      response.should_not have_selector("div.ltl-menu")
    end
  end

  describe 'POST login' do

    it "should create a user with just a :email and :password which when queried for errors should pass" do
      u = User.new(:password => "justatest", :email => "justa test")
      u.errors.any?.should be_false
    end

    describe "with invalid parameters" do
      before(:each) do
        request.env["HTTPS"] = "on"
      end

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

    describe "with valid user credentials" do
      before(:each) do
        request.env["HTTPS"] = "on"
        @params = {:email => "marc@email.com", :password => "password"}
      end

      it "should result in redirection to the project list page" do
        post :login, @params
        response.should redirect_to(projects_path)
      end

      it "should store the user object in the session" do 
        post :login, @params
        assigns(:current_user).should_not be_nil
      end
    end

  end

end

# error: forgot to add : before key in a map
