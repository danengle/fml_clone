class PostVote < Vote
  
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
