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
        assigns(:project).users.length.should eq(2)
      end

    end

    describe "security" do
      it "should only allow project collaborators to add collaborators" do
        bad_guy = Factory(:user, :email => "unathorized@email.com")
        collaborator = Factory(:user, :email => "collaborator@playnice.com", :active => true)
        login_as(bad_guy)
        post :create, :project_id => @proj.id, :user => collaborator
        response.should redirect_to(home_path)
      end
    end
  end

  # non of the below seem to be getting through to the to delete method but they seems to be 
  # going somewhere ?? beats me
  describe "DELETE destroy" do
    before(:each) do
      @user1 = Factory(:user, :email => "excellent@excellent.com")
      @user2 = Factory(:user, :email => "mostexcellent@excellent.com")
      @proj = Factory(:project, :users => [@user1, @user2])
      login_as(@user1)
    end

    it "c !E Clb-set => project_path w/ flash error message" do
      @user = Factory(:user)
      delete :destroy, :project_id => @proj.id.to_s, :id => @user.id.to_s
      flash[:notice].should_not be_nil
      assigns(:project).users.length.should eq(2)
      response.should redirect_to(edit_project_path(@proj))
    end

    it "c E Clb-set => project_path w/ flash success message" do
      delete :destroy, :project_id => @proj.id, :id => @user2.id
      assigns(:project).users.length.should eq(1)
      response.should redirect_to(edit_project_path(@proj))
    end

    it "if a user removes himself from a project then he should be redirected to the project list page" do
      delete :destroy, :project_id => @proj.id, :id => @user1.id
      assigns(:project).users.length.should eq(1)
      response.should redirect_to(projects_path)
    end

  end

end

# error: did not finish entering ending ')'s
# error: typo describe was 'describle'
# error: in my tests I never logged in and couldnt figure out what was going on, wasted a lot of time
# error: forgot to add : before map key
