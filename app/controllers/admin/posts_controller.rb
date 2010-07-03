class Admin::PostsController < ApplicationController
  layout 'admin'
  before_filter :admin_required
  
  # GET /posts
  # GET /posts.xml
  def index
    @new_posts = Post.need_review.all
    @posts = Post.reviewed.paginate(:page => params[:page], :per_page => 10)
    @future_posts = Post.future_posts.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    @post.read! if @post.unread?
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])

    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to([:admin,@post]) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to([:admin,@post]) }
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
    if @post.publish(params[:date])
      flash[:notice] = "Post #{@post.id} has been scheduled for publishing."
      redirect_to edit_admin_post_path(@post)
    else
      render 'edit'
    end
  end
  
  def unpublish
    @post = Post.find(params[:id])
    @post.deny!
    flash[:notice] = "Post #{@post.id} has been unpublished."
    redirect_to edit_admin_post_path(@post)
  end
  
  def get_short_url
    @post = Post.find(params[:id])
    #logger.info { "#{@preferences[:bitly_username]}" }
    #logger.info { "#{@preferences[:bitly_api_key]}" }
    # "http://api.bit.ly/v2/validate?x_login=developingdan&x_apiKey=R_a886861c1945dcefe627a22abd737b6f"
    url = URI.parse("http://api.bit.ly/v3/shorten?login=#{@preferences[:bitly_username]}&apiKey=#{@preferences[:bitly_api_key]}ss&longUrl=#{URI.encode(post_url(@post))}&format=json")
    # url = URI.parse("http://api.bit.ly/v3/shorten?login=developingdan&apiKey=R_a886861c1945dcefe627a22abd737b6f&longUrl=#{URI.encode(post_url(@post))}&format=json")
    logger.info { "url: #{url}" }
    #logger.info { "url: #{url.path}" }
    # req = Net::HTTP::Get.new(url.path)
    # logger.info { "req: #{}" }
    # res = Net::HTTP.start(url.host, url.port) {|http| logger.info { "req: #{http.request(req)}"};http.request(req) }
    res = Net::HTTP.get url
    res = ActiveSupport::JSON.decode(res)
    # logger.info { "raw_res: #{res}" }
    logger.info { "res: #{res}" }
    logger.info { "status_code: #{res["status_code"]}" }
    if res["status_code"] == 200
      @post.short_url = res["data"]["url"]
      @post.save
      flash[:notice] = "Successfully retrieved bit.ly shortened url."
    else
      flash[:error] = "Unable to get shortened url from bit.ly. Reason: #{res["status_txt"]}"
      logger.info { "couldn't retrieve short url with \n#{url}" }
    end
    redirect_to edit_admin_post_path(@post)
  end
  
  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.delete!
    flash[:notice] = "Post deleted."
    respond_to do |format|
      format.html { redirect_to(admin_posts_url) }
      format.xml  { head :ok }
    end
  end
end
