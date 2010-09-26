class CommentsController < ApplicationController

  before_filter :require_user
  before_filter :get_post

  # POST /comments
  # POST /comments.xml
  def create
    @comment = @post.comments.new(params[:comment])
    @comment.user = current_user
    @comment.ip_address = request.remote_ip
    @comment.user_agent = request.user_agent
    @comment.referrer = request.referrer
    @comment.akismet_api_key = @preferences[:akismet_api_key] unless @preferences[:akismet_api_key].blank?
    respond_to do |format|
      if @comment.save
        if @preferences[:akismet_api_key].blank? || @comment.approved?
          flash[:notice] = "Thanks for the comment."
        else
          flash[:error] = "This comment appears to be spam. It will show up once it has been reviewed."
        end
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        flash[:error] = 'There was an error creating your comment.'
        format.html { redirect_to(@post ) }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to(@comment, :notice => 'Thanks for commenting!') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def reply
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
    
  end
  
  protected
  def get_post
    @post = Post.find(params[:post_id])
  end
end
