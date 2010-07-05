class ModeratorVote < Vote

  
  def increment_counter
    if self.up_vote?
      self.post.increment!(:moderator_up_vote_counter)
    else
      self.post.increment!(:moderator_down_vote_counter)
    end
  end

  def decrement_counter
    if self.up_vote?
      self.post.decrement!(:moderator_up_vote_counter)
    else
      self.post.decrement!(:moderator_down_vote_counter)
    end
  end
end
