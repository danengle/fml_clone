class ApplicationController < ActionController::Base
  
  protect_from_forgery
  helper_method :current_user_session, :current_user
  
  before_filter :get_current_user
  before_filter :get_preferences
  
  def get_current_user
    current_user
  end
  
  def admin_required
    access_denied unless admin?
  end
  
  def access_denied
    store_location
    flash[:error] = "You are not authorized to access that page"
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
  helper_method :logged_in?
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
      flash[:error] = "You must be logged in to do that!"
      redirect_back_or_default root_path
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
    session[:return_to] = request.referer
  end

  def redirect_back_or_default(default)
    store_location
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def get_preferences
    preferences = Preference.find(:all)
    @preferences = {}
    preferences.each do |p|
      @preferences[p.key.to_sym] = p.value
    end
  end
  
=begin   
   # def render_optional_error_file(status_code)
     # status = interpret_status(status_code)
     # render :template => "errors/#{status[0,3]}.html.erb", :status => status, :layout => 'application.html.erb'
   # end
  # unless ActionController::Base.consider_all_requests_local
    # rescue_from Exception,                            :with => :render_error
    # rescue_from ActiveRecord::RecordNotFound,         :with => :render_not_found
    # rescue_from ActionController::RoutingError,       :with => :render_not_found
    # rescue_from ActionController::UnknownController,  :with => :render_not_found
    # rescue_from ActionController::UnknownAction,      :with => :render_not_found
  # end
  
  def local_request?
    false
  end
  protected
  
  def render_error(exception)
    render :template => "errors/500", :status => 404
  end
  
  def render_not_found(exception)
    render :template => "errors/404", :status => 404
  end
=end

# rescue_from ActiveRecord::RoutingError, :with => :render_record_not_found

# Catch record not found for Active Record
# def render_record_not_found
  # render :template => "errors/404", :layout => 'application', :status => 404
# end

# Catches any missing methods and calls the general render_missing_page method
# def method_missing(*args)
  # render_missing_page # calls my common 404 rendering method
# end

# General method to render a 404
# def render_missing_page
  # render :template => "errors/404", :layout => 'application', :status => 404
# end

end
