class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:create, :new]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new(params[:user_session])
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default root_path
    else
      flash[:error] = "Oops! You must have entered your username or password incorrectly."
      redirect_back_or_default root_path
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default root_path
  end
end
