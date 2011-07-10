
class EntranceController < ApplicationController

  def home
    @submitted_credentials = User.new
  end

  #process a submission of the user login form
  def login
    @submitted_credentials = User.new(params)

    @user = User.find_by_email(@submitted_credentials.email)
    if @user.nil?
      @submitted_credentials.errors.add(:email, "is not a associated with a valid user")
    else
      @submitted_credentials.errors.add(:not_active, "this account must be activated before use") if @user.active == false
      @submitted_credentials.errors.add(:password, "is not valid for the given email") if not @user.is_users_password?(@submitted_credentials.password)
    end
    
    respond_to do |format|
      if (@submitted_credentials.errors.empty?) 
        self.current_user = @user
        format.html { redirect_to(projects_path) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "home" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # this just forwards to the view which contains account activation instructions for new account
  def activation_instructions
  end

  # activates a users account
  def activate
    @user = User.new(params)
    @user.salt = params[:token]

    true_user = User.find_by_email(@user.email)
    if true_user.nil?
      @user.errors.add(:email, "the email is not registed in the system")
    else
      @user.errors.add(:token, "invalid authoization token") if true_user.salt != @user.salt
    end

    respond_to do |format|
      if @user.errors.empty?
        true_user.active = true
        true_user.save
        format.html { redirect_to(projects_path, :notice => "Welcome! your account has been activated to begin try creating a new project in the form at the top right") }
      else
        format.html { render :action => "activation_instructions" }
      end
    end
  end


end


# errors: forgot to add a @ before submitted_credentials (twice)
# errors: forgot to add '@submitted_credentials' before errors.any?
# errors: I knew users could be nil comming back from the activate method but then I use it for everything and still dont see whats going on, after a rest Im see it right away
# errors: for @user i typed @use
