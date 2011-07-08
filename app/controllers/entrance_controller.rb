
class EntranceController < ApplicationController

  def home
    @submitted_credentials = User.new
  end

  #process a submission of the user login form
  def login
    @submitted_credentials = User.new(params)

    @user = User.find_by_email(@submitted_credentials.email)
    @submitted_credentials.errors.add(:email, "is not a associated with a valid user") if @user.nil?
    
    respond_to do |format|
      if (not @submitted_credentials.errors.any?) and @user.is_users_password?(@submitted_credentials.password)
        format.html { redirect_to(projects_path) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        @submitted_credentials.errors.add(:password, "is not valid the given email") if not @submitted_credentials.errors.any?
        format.html { render :action => "home" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

end


# errors: forgot to add a @ before submitted_credentials (twice)
# errors: forgot to add '@submitted_credentials' before errors.any?
