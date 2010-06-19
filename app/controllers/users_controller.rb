class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.register!
      @user.reset_perishable_token!
      UserMailer.activation_email(@user).deliver
      flash[:notice] = "Account registered! Please check your email to activate your account and then you can login."
      redirect_to root_path
    else
      render :action => :new
    end
  end

  def show
    @user = User.find_by_id(params[:id]) || current_user
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
  
  def activate
    user = User.find_by_perishable_token(params[:activation_code])
    #logger.info { "User: #{user.login}" }
    #logger.info { "first when is #{(!params[:activation_code].blank?) && user && !user.active?}" }
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to root_path
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default new_account_url
    else
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default new_account_url
    end
  end
  
  #TODO add some checks for users who are already activated and non existent emails
  def new_activation_email
    if request.post?
      @user = User.find_by_email(params[:email])
      @user.reset_perishable_token!
      UserMailer.activation_email(@user).deliver
      flash[:notice] = "Check your email for a new activation link"
      redirect_back_or_default root_path
    else
      @user = User.new
    end
  end
  
  def reset_password
    if request.post?
      @user = User.find_by_email(params[:email])
      @user.reset_perishable_token!
      UserMailer
    end
  end
end
