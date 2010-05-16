class Page < ActiveRecord::Base
  validates_presence_of :title, :slug, :body
  validates_uniqueness_of :title, :slug
  
  before_save :generate_slug
  
  def generate_slug
    self.slug = self.title.to_slug
  end
end
