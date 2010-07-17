class Admin::DashboardController < ApplicationController
  respond_to :html
  before_filter :admin_required
  layout 'admin'
  
  def index
    @changes = ChangeLog.order('created_at desc').paginate(:page => params[:page], :per_page => 50)
    respond_with(@changes)
  end
end