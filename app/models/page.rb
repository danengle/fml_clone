class Page < ActiveRecord::Base
  validates_presence_of :title, :slug, :body
  validates_uniqueness_of :title, :slug
end
