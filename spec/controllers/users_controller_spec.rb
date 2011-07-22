require 'spec_helper'

describe UsersController do

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {password: "apassword", email: "auser@mail.com", password_confirmation: "apassword"}
  end
  
  def login_as(u)
    session[:user_id] = u.id
  end

  let(:user) do
    User.find_by_email("marc@email.com")
  end

  # describe "GET index" do
  #   before(:each) do
  #     login_as user
  #   end

  #   it "assigns all users as @users" do
  #     user = User.create! valid_attributes
  #     get :index
  #     assigns(:users).should include(user)
  #   end
  # end

  # describe "GET show" do
  #   before(:each) do
  #     login_as user
  #   end

  #   it "assigns the requested user as @user" do
  #     user = User.create! valid_attributes
  #     get :show, :id => user.id.to_s
  #     assigns(:user).should eq(user)
  #   end
  # end

  describe "GET new" do
    before(:each) do
      request.env["HTTPS"] = "on"
    end

    it "assigns a new user as @user" do
      get :new
      assigns(:user).should be_a_new(User)
    end

  end

  # describe "GET edit" do
  #   before(:each) do
  #     login_as user
  #   end

  #   it "assigns the requested user as @user" do
  #     user = User.create! valid_attributes
  #     get :edit, :id => user.id.to_s
  #     assigns(:user).should eq(user)
  #   end
  # end

  describe "POST create" do
    before(:each) do
      request.env["HTTPS"] = "on"
    end

    describe "with valid params" do
      it "creates a new User" do
        expect {
          post :create, :user => valid_attributes
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :create, :user => valid_attributes
        assigns(:user).should be_a(User)
        assigns(:user).should be_persisted
      end

      it "redirects to the created user" do
        post :create, :user => valid_attributes
        response.should redirect_to(activation_instructions_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, :user => {}
        assigns(:user).should be_a_new(User)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, :user => {}
        response.should render_template("new")
      end
    end
  end

  # describe "PUT update" do
  #   before(:each) do
  #     login_as user
  #   end

  #   describe "with valid params" do
  #     it "updates the requested user" do
  #       user = User.create! valid_attributes
  #       # Assuming there are no other users in the database, this
  #       # specifies that the User created on the previous line
  #       # receives the :update_attributes message with whatever params are
  #       # submitted in the request.
  #       User.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
  #       put :update, :id => user.id, :user => {'these' => 'params'}
  #     end

  #     it "assigns the requested user as @user" do
  #       user = User.create! valid_attributes
  #       put :update, :id => user.id, :user => valid_attributes
  #       assigns(:user).should eq(user)
  #     end

  #     it "redirects to the user" do
  #       user = User.create! valid_attributes
  #       put :update, :id => user.id, :user => valid_attributes
  #       response.should redirect_to(user)
  #     end
  #   end

  #   describe "with invalid params" do
  #     it "assigns the user as @user" do
  #       user = User.create! valid_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       User.any_instance.stub(:save).and_return(false)
  #       put :update, :id => user.id.to_s, :user => {}
  #       assigns(:user).should eq(user)
  #     end

  #     it "re-renders the 'edit' template" do
  #       user = User.create! valid_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       User.any_instance.stub(:save).and_return(false)
  #       put :update, :id => user.id.to_s, :user => {}
  #       response.should render_template("edit")
  #     end
  #   end
  # end

  # describe "DELETE destroy" do
  #   before(:each) do
  #     login_as user
  #   end

  #   it "destroys the requested user" do
  #     user = User.create! valid_attributes
  #     expect {
  #       delete :destroy, :id => user.id.to_s
  #     }.to change(User, :count).by(-1)
  #   end

  #   it "redirects to the users list" do
  #     user = User.create! valid_attributes
  #     delete :destroy, :id => user.id.to_s
  #     response.should redirect_to(users_url)
  #   end
  # end

end
