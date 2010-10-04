class Admin::PostsController < ApplicationController
  layout 'admin'
  before_filter :admin_required

  # GET /posts
  # GET /posts.xml
  def index
    @new_posts = Post.need_review.all
    @posts = Post.visible.reviewed.paginate(:page => params[:page], :per_page => 10)
    @future_posts = Post.future_posts.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    if @post.unread?
      @post.read!
      @post.short_url = Bitly.get_short_url(@post, post_url(@post), @preferences)
    end
    @changes = ChangeLog.for_post(@post).paginate(:page => params[:page], :per_page => 10)
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to(edit_admin_post_path(@post)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  #TODO figure out a better way to catch date errors
  def publish
    @post = Post.find(params[:id])
    if @post.set_date(params[:date])
      @post.publish!
      flash[:notice] = "Post #{@post.id} has been scheduled for publishing."
      redirect_to edit_admin_post_path(@post)
    else
      render 'edit'
    end
  end
  
  def unpublish
    @post = Post.find(params[:id])
    @post.unpublish!
    flash[:notice] = "Post #{@post.id} has been unpublished."
    redirect_to edit_admin_post_path(@post)
  end
  
  def deny
    @post = Post.find(params[:id])
    @post.deny!
    flash[:notice] = "Post #{@post.id} has been denied."
    redirect_to edit_admin_post_path(@post)
  end
  
  def undeny
    @post = Post.find(params[:id])
    @post.undeny!
    flash[:notice] = "Post #{@post.id} is no longer denied."
    redirect_to edit_admin_post_path(@post)
  end
  
  def get_short_url
    @post = Post.find(params[:id])
    @post.short_url = Bitly.get_short_url(@post, post_url(@post), @preferences)
    # debugger
    if @post.save
      flash[:notice] = "Successfully created bit.ly shortened url."
    else
      flash[:error] = "Unable to get shortened url from bit.ly. Reason: #{@post.errors.on('short_url')}"
    end
    redirect_to edit_admin_post_path(@post)
  end
  
  def delete_short_url
    @post = Post.find(params[:id])
    @post.short_url = nil
    @post.save
    flash[:notice] = "Successfully deleted shortened url for this post."
    redirect_to edit_admin_post_path(@post)
  end
  
  # DELETE /admin/posts/1
  def destroy
    @post = Post.find(params[:id])
    @post.delete!
    flash[:notice] = "Post deleted."
    format.html { redirect_to(admin_posts_url) }
  end
end
