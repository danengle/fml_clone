class Preference < ActiveRecord::Base
  acts_as_change_logger
  belongs_to :preference_category
  has_one :feature
  
  #TODO do something with the 'required' column?
  validates_uniqueness_of :key
  validates_presence_of :key
  validates_presence_of :value, :if => Proc.new{|pref| pref.required? }
  validate :required_cant_be_disabled
  
  scope :general, where({:preference_category_id => 1})
  scope :positioned, order('position asc')
  
  def required_cant_be_disabled
    errors.add_to_base("A required preference can't be disabled.") if required == true && disabled == true
  end
end
