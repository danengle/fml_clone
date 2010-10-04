class Admin::CategoriesController < ApplicationController
  before_filter :admin_required
  layout 'admin'
  respond_to :html, :xml, :json
  # GET /categories
  # GET /categories.xml
  def index
    @categories = Category.paginate(:page => params[:page], :per_page => 20)
    respond_with(@categories)
  end

  # GET /categories/new
  # GET /categories/new.xml
  def new
    @category = Category.new
    respond_with(@categories)
  end

  # GET /categories/1/edit
  def edit
    @category = Category.find_by_slug(params[:id])
  end

  # POST /categories
  # POST /categories.xml
  def create
    @category = Category.new(params[:category])
    
    respond_to do |format|
      if @category.save
        format.html { redirect_to(admin_categories_path, :notice => 'Category was successfully created.') }
        format.xml  { render :xml => @category, :status => :created, :location => @category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.xml
  def update
    @category = Category.find_by_slug(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to(admin_categories_path, :notice => 'Category was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.xml
  # TODO get destroy link in admin/categories/index working
  def destroy
    @category = Category.find_by_slug(params[:id])

    if @category.can_destroy?
      @category.destroy
      flash[:notice] = "Successfully destroyed category."
    else
      flash[:error] = "This category can't be destroyed. There are #{@category.posts.size} posts with this category."
    end

    respond_to do |format|
      format.html { redirect_to(admin_categories_url) }
      format.xml  { head :ok }
    end
  end
end
