class Admin::SearchController < ApplicationController
  respond_to :html
  before_filter :admin_required
  layout 'admin'
  
  def index
    @results = ThinkingSphinx.search(params[:q], :page => params[:page], :per_page => 15)
    respond_with(@results)
  end
end