class PostsController < ApplicationController
  
  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.published.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new
    # @comment = @post.comments.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])
    @post.user = current_user if logged_in?
    respond_to do |format|
      if @post.save
        format.html { redirect_to(@post, :notice => 'Post was successfully created.') }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def up_vote
    @post = Post.find(params[:id])
    vote = @post.votes.new(:up_vote => true)
    vote.user = current_user if logged_in?
    if vote.save
      flash[:notice] = "Thanks for voting!"
    else
      flash[:notice] = "Could not save your vote, sorry."
    end
    redirect_to :back
  end
  
  def down_vote
    @post = Post.find(params[:id])
    vote = @post.votes.new(:up_vote => false)
    vote.user = current_user if logged_in?
    if vote.save
      flash[:notice] = "Thanks for voting!"
    else
      flash[:notice] = "Could not save your vote, sorry."
    end
    redirect_to :back
  end
  
  #TODO fix this random post generator
  def random
    @post = Post.published.where(['id >= ?', rand(Post.count)]).first
    @comment = @post.comments.new
    render :action => 'show'
  end
  
  def top_rated
    @time_period = case params[:time_period]
    when 'week'
      Time.now.beginning_of_week
    when 'month'
      Time.now.beginning_of_month
    when 'year'
      Time.now.beginning_of_year
    else
      Time.now - 10.years
    end
    @posts = Post.published.where(['published_at >= ?', @time_period]).order('up_vote_counter desc')
  end
end
