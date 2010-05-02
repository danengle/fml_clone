class CommentsController < ApplicationController

  before_filter :require_user
  before_filter :get_post

  # POST /comments
  # POST /comments.xml
  def create
    @comment = @post.comments.new(params[:comment])
    @comment.user = current_user
    # @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html { redirect_to(@post, :notice => 'Comment was successfully created.') }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        flash[:error] = 'There was an error creating your comment.'
        logger.info { "*** #{@comment.errors}" }
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
