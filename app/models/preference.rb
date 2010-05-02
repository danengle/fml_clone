class Preference < ActiveRecord::Base
  belongs_to :preference_category
  
  validates_uniqueness_of :key
  validates_presence_of :key, :value
  
  scope :general, where({:preference_category_id => 1})
end
