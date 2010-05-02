class Comment < ActiveRecord::Base
  validates_presence_of :user_id, :post_id, :body

  belongs_to :post
  belongs_to :user
  has_many :replies, :class_name => 'Comment', :foreign_key => 'parent_id', :order => 'created_at'
  
  scope :parent_comments, where({:parent_id => nil})
  scope :siblings, lambda { |parent_id| where({:parent_id => parent_id}) } 
  
  def first_child?
    self.siblings.each do |sibling|
      return false if self.created_at > sibling.created_at
    end
    true
  end
  
  def last_child?
    self.siblings.each do |sibling|
      return false if self.created_at < sibling.created_at
    end
    true
  end
  
  def siblings
    Comment.siblings(self.id).all
  end
end
