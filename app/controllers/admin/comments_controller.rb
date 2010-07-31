class Admin::CommentsController < ApplicationController
  layout 'admin'
  before_filter :admin_required
  before_filter :get_post

  # GET /posts/1/edit
  def edit
    @comment = @post.comments.find(params[:id])
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @comment = @post.comments.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to(edit_admin_post_comment_path(@post, @comment)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end
    
  # DELETE /admin/posts/1
  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.delete!
    flash[:notice] = "Comment deleted."
    format.html { redirect_to(edit_admin_posts_url(@post)) }
  end
  
  private
  
  def get_post
    @post = Post.find(params[:post_id])
  end
end
