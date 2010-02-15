class Vote < ActiveRecord::Base
  validates_presence_of :post_id

  belongs_to :post
  belongs_to :user

  def after_create
    if self.up_vote?
      self.post.increment!(:up_vote_counter)
    else
      self.post.increment!(:down_vote_counter)
    end
  end

  def after_destroy
    if self.up_vote?
      self.post.decrement!(:up_vote_counter)
    else
      self.post.decrement!(:down_vote_counter)
    end
  end
end
