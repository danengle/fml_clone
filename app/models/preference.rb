class Preference < ActiveRecord::Base
  belongs_to :preference_category
  has_one :feature
  
  #TODO do something with the 'required' column?
  validates_uniqueness_of :key
  validates_presence_of :key
  validates_presence_of :value, :if => Proc.new{|pref| pref.required? }
  
  scope :general, where({:preference_category_id => 1})
  scope :positioned, order('position asc')
end
