class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user_session, :current_user
  
  before_filter :get_current_user
  
  def get_current_user
    current_user
  end
  
  def admin_required
    access_denied unless admin?
  end
  
  def access_denied
    store_location
    flash[:notice] = "You are not authorized to access this page"
    logger.info { "User attempted unathorized access to #{request.request_uri}" }
    logger.info { "session[:return_to] = #{session[:return_to]}" }
    redirect_to root_path # figure out best way to use :back
    return false
  end
  
  def admin?
    current_user && current_user.admin?
  end
  helper_method :admin?
  
  def logged_in?
    !current_user.blank?
  end
  
  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to account_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
