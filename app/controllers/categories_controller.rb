class CategoriesController < ApplicationController
  respond_to :html, :xml, :json, :rss
  
  def index
  end
  
  def show
    @category = Category.find_by_slug(params[:id])
    @posts = Post.published.by_category(@category).sort_by_published.paginate(:page => params[:page])
    respond_with(@posts)
  end
end