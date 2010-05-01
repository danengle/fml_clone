class FavoritesController < ApplicationController
  before_filter :require_user
  
  def index
    # @posts = Post
  end
  
  def create
    @post = Post.find(params[:post_id])
    favorite = Favorite.create(
      :user_id => current_user.id,
      :post_id => @post.id
    )
    flash[:notice] = "Post has been favorited."
    redirect_back_or_default post_path(@post)
  end
  
  def destroy
    
  end
end
