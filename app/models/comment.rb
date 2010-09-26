class Comment < ActiveRecord::Base
  
  acts_as_change_logger
    
  validates_presence_of :user_id, :post_id, :body

  belongs_to :post
  belongs_to :user
  has_many :replies, :class_name => 'Comment', :foreign_key => 'parent_id', :order => 'created_at'
  
  scope :parent_comments, where({:parent_id => nil})
  scope :siblings, lambda { |parent_id| where({:parent_id => parent_id}) } 
  
  before_create :check_for_spam
  
  attr_accessor :akismet_api_key
  
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
    Comment.siblings(self.parent_id).all
  end
  
  def children
    Comment.where(:parent_id => self.id)
  end

  def check_for_spam
    self.approved = !::Akismetor.spam?(akismet_attributes)
    true # return true so it doesn't stop save
  end
  
  def akismet_attributes
    {
      :key                  => akismet_api_key,
      :blog                 => 'http://fml.danengle.me',
      :user_ip              => ip_address,
      :user_agent           => user_agent,
      :comment_author       => user.full_name,
      :comment_author_email => user.email,
      :comment_content      => body
    }
  end
  
  # TODO remabe approved attribute to spam. double negatives suck
  def mark_as_spam!
    update_attribute(:approved, true)
    Akismetor.submit_spam(akismet_attributes)
  end
  
  def mark_as_ham!
    update_attribute(:approved, false)
    Akismetor.submit_ham(akismet_attributes)
  end
  
end
