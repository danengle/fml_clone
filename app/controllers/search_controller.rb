class SearchController < ApplicationController
  
  def index
    @posts = Post.search(params[:q],:page => params[:page], :per_page => @preferences[:posts_per_page])
    # logger.info { "results: #{@posts}" }
  end
end
