class PostsController < ApplicationController
  respond_to :html, :xml, :json, :rss
  # GET /posts
  # GET /posts.xml
  def index
    @posts = Post.published.paginate(:page => params[:page], :per_page => @preferences[:posts_per_page])
    respond_with(@posts)
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @stuff = request
    @post = Post.find(params[:id])
    respond_with(@post)
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new
    # @comment = @post.comments.new
    respond_with(@post)
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])
    @post.user = current_user if logged_in?
    respond_to do |format|
      if @post.save
        format.html { redirect_to(root_path, :notice => 'Thank you for you submission. It will have to be reviewed before it appears on the site.') }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  #TODO move up_vote and down_vote to votes_controller
  def up_vote
    @post = Post.find(params[:id])
    vote = @post.votes.new(:up_vote => true)
    vote.user = current_user if logged_in?
    if vote.save
      flash[:notice] = "Thanks for voting!"
    else
      flash[:error] = vote.errors.blank? ? "Could not save your vote, sorry." : vote.errors[:post_id].first
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
      flash[:error] = vote.errors.blank? ? "Could not save your vote, sorry." : vote.errors[:post_id].first
    end
    redirect_to :back
  end
  
  #TODO fix this random post generator
  def random
    @post = Post.published.random_record.first #where(['id >= ?', rand(Post.count)]).first
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
