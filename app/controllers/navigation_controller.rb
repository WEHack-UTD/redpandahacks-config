class NavigationController < ApplicationController
  def index
    if !user_signed_in?
      redirect_to new_user_session_path
    end
  end

  def admin
    unless current_user.is_admin?
      redirect_to index_path, alert: 'You do not have the permissions to visit the admin page'
    end

    @all_admins = User.where(user_type: 'admin')
    @all_organizers = User.where(user_type: 'organizer')
    @all_mentors = User.where(user_type: 'mentor')
  end

  def add_permissions

    # Check if the user doing this is admin
    if current_user.is_admin?

      if params[:add_admin].present?
        @user = User.where(email: params[:add_admin]).first
        if @user.nil?
          redirect_to admin_path, alert: "Could not find user with email #{params[:add_admin]}"
        else
          @user.user_type = 'admin'
          @user.save
          redirect_to admin_path, notice: "#{params[:add_admin]} is now an admin"
        end
      end

      if params[:add_organizer].present?
        @user = User.where(email: params[:add_organizer]).first
        if @user.nil?
          redirect_to admin_path, alert: "Could not find user with email #{params[:add_organizer]}"
        else
          @user.user_type = 'organizer'
          @user.save
          redirect_to admin_path, notice: "#{params[:add_organizer]} is now an organizer"
        end
      end

      if params[:add_mentor].present?
        @user = User.where(email: params[:add_mentor]).first
        if @user.nil?
          redirect_to admin_path, alert: "Could not find user with email #{params[:add_mentor]}"
        else
          @user.user_type = 'mentor'
          @user.save
          redirect_to admin_path, notice: "#{params[:add_mentor]} is now a mentor"
        end
      end




    end
  end



end
