class PasswordController < ApplicationController
  before_filter :require_no_user #, :only => [:new, :create]
  # before_filter :require_user, :only => [:index, :show, :edit, :update]
  # new_password_path, /account/new_password
  def new
  end
  
  # send_password_reset_path
  def create
    @user = User.find_by_email(params[:email])
    @user.reset_perishable_token!
    UserMailer.password_reset_email(@user).deliver
    flash[:notice] = "Check your email for a password reset link."
    redirect_back_or_default root_path
  end
  
  # /account/reset_password/:reset_code
  def edit
    @user = User.find_by_perishable_token(params[:reset_code])
    if @user.blank?
      flash[:error] = "That password reset link is not working. Make sure you're entering the url correctly or try resetting your password again"
      redirect_back_or_default new_password_path
      return
    end
    # @user.reset_perishable_token!
  end
  
  
  def update
    @user = User.find_by_perishable_token(params[:reset_code])
    logger.info { "\n\n@user = #{@user.inspect}\n\n" }
    if @user && @user.new_password(params[:p])
      flash[:notice] = "Your password has been reset."
      redirect_to root_path
    else
      logger.info { "@user.errors = #{@user.errors}" }
      render 'edit'
    end
  end
end