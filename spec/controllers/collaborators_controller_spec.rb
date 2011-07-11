require 'spec_helper'

describe CollaboratorsController do
  
  def login_as(user)
    session[:user_id] = user.id
  end

  describe "POST 'create'" do
    before(:each) do
      @owner = Factory(:user, :active => true)
      @proj = Factory(:project, :users => [@owner])
      login_as(@owner)
    end

    describe "logic" do
      it "if c E C-set                     then C-set == C-set'" do
        post :create, :project_id => @proj.id, :user => {:email => @owner.email}
        flash[:notice].should_not be_nil
        assigns(:project).users.length.should eq(1)
      end

      it "if c !E Clb-set and c E User-set then Clb-set.size + 1 = C-set'.size" do
        @collaborator = Factory(:user, :email => "collaborator@playnice.com", :active => true)
        post :create, :project_id => @proj.id, :user => {:email => @collaborator.email}
        flash[:success].should_not be_nil
        assigns(:project).users.length.should eq(2)
      end

      it "if c !E Clb-set and c !E Usr-set then Clb-set.size + 1 = Clb-set'.size and Usr.size + 1 = Usr'.size and email"
    end

    describe "page flow" do
      it "non email format => project_path w/form validation error, bad format"
      it "if c E C-set                     => project_path w/ flash notice, already collaborator"
      it "if c !E Clb-set and c E User-set => project_path w/ flash successe"
      it "if c !E Clb-set and c !E Usr-set => project_path w/ flash sucess, has been invited"
    end

    describe "security" do
      it "should only allow project collaborators to add an delete collaborators"
    end
  end

  describe "PUT'delete'" do
    it "c !E Clb-set => project_path w/ flash error message"
    it "c E Clb-set => project_path w/ flash success message"

    describe "security" do
    end
  end

end

# error: did not finish entering ending ')'s
# error: typo describe was 'describle'
