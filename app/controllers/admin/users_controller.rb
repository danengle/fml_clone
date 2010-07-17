class Admin::UsersController < ApplicationController

  before_filter :admin_required
  before_filter :find_user, :only => [:show, :edit, :update, :activate, :suspend, :unsuspend, :delete, :purge]
  layout 'admin'
  
  def index
    @users = User.not_deleted.paginate(:page => params[:page], :per_page => 10)
  end
  
  def show
    redirect_to edit_admin_user_path(@user)
  end
  
  def edit
    @posts = @user.posts.paginate(:page => params[:page], :per_page => 10)
    @changes = @user.changes.limit(20)
  end
  
  def update
    # TODO move this to check to model? hard to unless there is access to current_user in model
    params[:user].delete(:admin) if current_user == @user
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

  def activate
    logger.info { "** #{@user.inspect} **" }
    @user.activate!
    redirect_to edit_admin_user_path(@user), :notice => "#{@user.login} has been activated."
  end
  
  def suspend
    @user.suspend!
    UserMailer.account_suspended_email(@user).deliver
    redirect_to edit_admin_user_path(@user), :notice => 'User has been suspended.'
  end

  def unsuspend
    @user.unsuspend!
    UserMailer.account_unsuspended_email(@user).deliver
    redirect_to edit_admin_user_path(@user), :notice => 'User has been unsuspended.'
  end

  def delete
    # logger.info { "@user == current_user = #{@user == current_user}" }
    # TODO move this validation to model, but current_user is a prob in model
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
