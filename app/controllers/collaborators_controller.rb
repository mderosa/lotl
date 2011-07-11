class CollaboratorsController < ApplicationController

  # POST /projects/:project_id/collaborators
  # params = {:project_id => n, :user[:email] => m}
  def create
    @user = User.find_by_email(params[:user][:email])
    @project = Project.find(params[:project_id])

    if not @user.nil?
      if @project.users.include? @user
        flash[:notice] = "#{@user.email} is already a collaborator"
      else
        @project.users << @user
        @project.save
        flash[:success] = 'Collaborator was added'
      end
      redirect_to edit_project_path(@project)
    else
      flash[:warning] = "not implemented"
    end
  end

  # DELETE /projects/:project_id/collaborators/:user_id
  # params = {:project_id => n, :user_id => m}
  def destroy
    respond_to do |format|
    end
  end

end

# error: forgot to add @ before a class member
