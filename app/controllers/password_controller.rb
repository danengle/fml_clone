class PasswordController < ApplicationController
  before_filter :require_no_user #, :only => [:new, :create]
  # before_filter :require_user, :only => [:index, :show, :edit, :update]
  # new_password_path
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
  
  def edit
    @user = User.find_by_perishable_token(params[:reset_code])
    # @user.reset_perishable_token!
  end
  
  
  def update
    @user = User.find_by_perishable_token(params[:reset_code])
    if @user.new_password(params[:p])
      flash[:notice] = "Your password has been reset."
      redirect_back_or_default root_path
    else
      logger.info { "@user.errors = #{@user.errors}" }
      render 'edit'
    end
  end
end