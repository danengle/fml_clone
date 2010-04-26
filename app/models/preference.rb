class Preference < ActiveRecord::Base
  belongs_to :preference_category
  
  validates_uniqueness_of :key
  validates_presence_of :key, :value
  
end
