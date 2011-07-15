class CollaboratorsController < ApplicationController
  before_filter :authorize

  # POST /projects/:project_id/collaborators
  # params = {:project_id => n, :user[:email] => m}
  def create
    @user = User.find_by_email(params[:user][:email])
    @project = Project.find(params[:project_id])

    if not @user.nil?
      if @project.users.include? @user
        flash[:notice] = "#{@user.email} #{t('flash.msg.is-collaborator')}"
      else
        @project.users << @user
        @project.save
      end
    else
      flash[:notice] = "#{params[:user][:email]} #{t('flash.msg.not-registered')}"
    end
    redirect_to edit_project_path(@project)
  end

  # DELETE /projects/:project_id/collaborators/:user_id
  # params = {:project_id => n, :id => m}
  def destroy
    @project = Project.find(params[:project_id])
    user = User.find(params[:id])
    if not @project.users.include?(user)
      flash[:notice] = t("flash.msg.already-removed")
    else 
      @project.users.delete(user)
    end

    if user == current_user
      redirect_to projects_path
    else
      redirect_to edit_project_path(@project)
    end
  end

  private

  def authorize
    p = Project.find(params[:project_id])
    if not p.users.include?(current_user)
      flash[:notice] = t("flash.msg.access-denied")
      redirect_to home_path
    end
  end

end

# error: forgot to add @ before a class member
