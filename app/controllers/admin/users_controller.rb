class Admin::UsersController < ApplicationController

  before_filter :admin_required
  before_filter :find_user, :only => [:show, :suspend, :unsuspend, :delete, :purge]
  layout 'admin'
  
  def index
    @users = User.all
  end
  
  def show
    redirect_to edit_admin_user_path(@user)
  end
  
  def edit
    @user = User.find(params[:id])
    @posts = @user.posts.all
  end
  
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "Updated user"
        format.html { redirect_to edit_admin_user_path(@user) }
      else
        logger.info { @user.errors.inspect }
        format.html { render :action => "edit" }
      end
    end
  end

  def suspend
    @user.suspend!
    redirect_to edit_admin_user_path(@user), :notice => 'User has been suspended.'
  end

  def unsuspend
    @user.unsuspend!
    redirect_to edit_admin_user_path(@user), :notice => 'User has been unsuspended.'
  end

  def delete
    logger.info { "@user == current_user = #{@user == current_user}" }
    if @user == current_user
      flash[:error] = "You can't delete yourself!"
      redirect_to edit_admin_user_path(current_user)
    else
      @user.delete!
      flash[:notice] = 'User has been deleted.'
      redirect_to admin_users_path
    end
  end

  def purge
    @user.destroy
    redirect_to users_path
  end

  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

protected
  def find_user
    @user = User.find(params[:id])
  end
end
