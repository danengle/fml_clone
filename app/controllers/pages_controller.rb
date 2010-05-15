class PagesController < ApplicationController
  respond_to :html, :xml, :json
  
  def show
    @page = Page.find(params[:id])
    respond_with(@page)
  end
end