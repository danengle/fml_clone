class Vote < ActiveRecord::Base
  validates_presence_of :post_id
  validates_uniqueness_of :post_id, :scope => :user_id, :unless => Proc.new{|vote| vote.user_id == nil }, :message => "You already cast a vote for this post."
  validates_uniqueness_of :post_id, :scope => :session_id, :unless => Proc.new{|vote| vote.user_id != nil}, :message => "You already cast a vote for this post."
  
  belongs_to :post
  belongs_to :user

  after_create :increment_counter
  after_destroy :decrement_counter
  
end
