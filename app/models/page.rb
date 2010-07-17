class Page < ActiveRecord::Base
  acts_as_change_logger
  validates_presence_of :title, :slug, :body
  validates_uniqueness_of :title, :slug
  
  before_save :generate_slug
  
  def generate_slug
    self.slug = self.title.to_slug
  end
  
  def to_param
    slug
  end
end
