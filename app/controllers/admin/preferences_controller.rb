class Admin::PreferencesController < ApplicationController
  layout 'admin'
  before_filter :admin_required
  
  # GET /preferences
  # GET /preferences.xml
  def index
    @preference_category = PreferenceCategory.find_by_name('general')
    @preferences = Preference.general.all
    respond_to do |format|
      format.html { render 'show' }
      format.xml  { render :xml => @preferences }
    end
  end

  # GET /preferences/1
  # GET /preferences/1.xml
  def show
    @preference_category = PreferenceCategory.find_by_name(params[:id].humanize)
    @preferences = @preference_category.preferences.positioned.all
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @preference }
    end
  end

  # GET /preferences/1/edit
  def edit
    @preference = Preference.find(params[:id])
  end

  # PUT /preferences/1
  # PUT /preferences/1.xml
  def update
    @preference = Preference.find(params[:id])
    
    respond_to do |format|
      if @preference.update_attributes(params[:preference])
        flash[:notice] = 'Preference was successfully updated.'
        format.html { redirect_to(admin_preference_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @preference.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def bulk_update
    @preference_category = PreferenceCategory.find_by_name(params[:preference_category])
    @preferences = @preference_category.preferences.positioned.all
    @errors = []
    params[:preferences].each do |pref|
      preference = Preference.find_by_key(pref[0])
      preference.value = pref[1]
      unless preference.feature.blank?
        feature = Feature.find_by_preference_id(preference.id)
        if params[:feature].blank?
          feature.deployed = false
        else
          feature.deployed = params[:feature][preference.key.to_sym]
        end
        feature.save
      end
      unless preference.save
        preference.errors.each_pair do |key, value|
          @errors << "#{preference.display_name} #{value[0]}"
        end
      end
    end
    if @errors.blank?
      flash[:notice] = "Preferences updated."
      redirect_to admin_preference_path(@preference_category.name.downcase)
    else
      render 'show'
    end
  end
  
  def export
    @preferences = PreferenceCategory.includes(:preferences).all
    @yaml = []
    @preferences.each do |pc|
      pcyaml = []
      pcyaml << pc.attributes.delete_if{|k,v| ['id', 'created_at', 'updated_ad'].include?(k)}
      pcyaml << pc.preferences.map{|pr| pr.attributes.delete_if{|k,v| ['id', 'created_at', 'updated_ad'].include?(k)} }
      @yaml << pcyaml
    end
    f = File.new("config/preferences.yml", "w+")
    f.write(@yaml.to_yaml)
    f.close
    redirect_to admin_preferences_path, :notice => "Export of preferences completed successfully."
  end

end
