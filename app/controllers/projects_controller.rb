class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :check_permissions, only: %i[index]

  def index
    @projects = Project.all
  end

  def show
  end


  def new
    if current_user.has_published_project?
      redirect_to project_path(current_user.project)
    end
    @project = Project.new
  end


  def edit
  end


  def create
    @project = Project.new(project_params)
    @project.user = current_user

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      begin
        @project = Project.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to index_path, alert: 'Looks like we could not find that project (404)'
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :description, :link, :team_members)
    end

    def check_permissions
      unless current_user.is_admin?
        redirect_to index_path, alert: 'You do not have the permissions to see all projects'
      end
    end
end
