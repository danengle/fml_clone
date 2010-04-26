class PreferenceCategory < ActiveRecord::Base
  has_many :preferences
  
  validates_uniqueness_of :name
  validates_presence_of :name
end
