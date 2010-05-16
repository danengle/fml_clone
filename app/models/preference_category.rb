class PreferenceCategory < ActiveRecord::Base
  has_many :preferences
  
  validates_uniqueness_of :name
  validates_presence_of :name
  
  scope :positioned, order('position asc')
  
  before_save :generate_slug
  
  def generate_slug
    self.slug = self.name.to_slug
  end
end
