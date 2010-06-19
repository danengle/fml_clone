class Category < ActiveRecord::Base
  has_many :posts
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  before_save :generate_slug
  
  def generate_slug
    self.slug = self.name.to_slug
  end
  
  def to_param
    slug
  end
end
