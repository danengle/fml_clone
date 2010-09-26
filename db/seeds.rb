# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
PreferenceCategory.delete_all
Preference.delete_all
yaml = YAML::load_file("config/preferences.yml")
yaml.each do |pc|
  attributes = pc.delete_at(0)
  preference_category = PreferenceCategory.create(attributes)
  pc.each do |preferences|
    preferences.each do |pref|
      Preference.create(pref.merge!(:preference_category_id => preference_category.id))
    end
  end
end