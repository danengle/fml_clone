class FavoritesController < ApplicationController
  before_filter :require_user, :except => :index
  
  def index
    @user = User.find(params[:user_id])
    @posts = @user.favorite_posts.paginate(:page => params[:page])
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
