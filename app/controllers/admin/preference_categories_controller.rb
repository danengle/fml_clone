class Admin::PreferenceCategorysController < ApplicationController
  layout 'admin'
  before_filter :admin_required
  
  # GET /preference_categorys
  # GET /preference_categorys.xml
  def index
    @preference_categorys = PreferenceCategory.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @preference_categorys }
    end
  end

  # GET /preference_categorys/1
  # GET /preference_categorys/1.xml
  def show
    @preference_category = PreferenceCategory.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @preference_category }
    end
  end

  # GET /preference_categorys/new
  # GET /preference_categorys/new.xml
  def new
    @preference_category = PreferenceCategory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @preference_category }
    end
  end

  # GET /preference_categorys/1/edit
  def edit
    @preference_category = PreferenceCategory.find(params[:id])
  end

  # POST /preference_categorys
  # POST /preference_categorys.xml
  def create
    @preference_category = PreferenceCategory.new(params[:preference_category])

    respond_to do |format|
      if @preference_category.save
        flash[:notice] = 'PreferenceCategory was successfully created.'
        format.html { redirect_to(admin_preference_categorys_path) }
        format.xml  { render :xml => @preference_category, :status => :created, :location => @preference_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @preference_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /preference_categorys/1
  # PUT /preference_categorys/1.xml
  def update
    @preference_category = PreferenceCategory.find(params[:id])

    respond_to do |format|
      if @preference_category.update_attributes(params[:preference_category])
        flash[:notice] = 'PreferenceCategory was successfully updated.'
        format.html { redirect_to(admin_preference_category_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @preference_category.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /preference_categorys/1
  # DELETE /preference_categorys/1.xml
  def destroy
    @preference_category = PreferenceCategory.find(params[:id])
    @preference_category.delete!
    flash[:notice] = "PreferenceCategory deleted."
    respond_to do |format|
      format.html { redirect_to(admin_preference_categories_url) }
      format.xml  { head :ok }
    end
  end
end
