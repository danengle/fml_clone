class Vote < ActiveRecord::Base
  validates_presence_of :post_id
  validates_uniqueness_of :post_id, :scope => :user_id, :unless => Proc.new{|vote| vote.user_id == nil }, :message => "You already cast a vote for this post."
  validates_uniqueness_of :post_id, :scope => :session_id, :unless => Proc.new{|vote| vote.user_id != nil}, :message => "You already cast a vote for this post."
  
  belongs_to :post
  belongs_to :user

  after_create :increment_counter
  after_destroy :decrement_counter
  
  def increment_counter
    if self.up_vote?
      self.post.increment!(:up_vote_counter)
    else
      self.post.increment!(:down_vote_counter)
    end
  end

  def decrement_counter
    if self.up_vote?
      self.post.decrement!(:up_vote_counter)
    else
      self.post.decrement!(:down_vote_counter)
    end
  end
end
