module PostsHelper
  def admin_post_creator_link(post)
    post.user.blank? ? 'anonymous' : link_to(post.user.login, edit_admin_user_path(post.user))
  end
  
  def published_time(post)
    post.published_at.blank? ? 'Not Published' : post.published_at.to_s(:long)
  end
  
  def post_times(post)
    post.published? ? "#{post.state}: #{post.published_at.to_s(:long)}" : "#{post.state}: created #{post.created_at.to_s(:long)}"
  end
  
  #TODO find out why links are alright on Safari but not Firefox
  def tweet_this_link(post)
    "http://twitter.com/?status=#{URI.escape("RT @#{@preferences[:twitter_username]} #{truncate(post.body, :length => 40)} #{post.short_url}", Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"
  end
  
  def facebook_this_link(post)
    "http://facebook.com/this_doesnt_work_now"
  end
  
  def display_name(post)
    # user.blank? ? @preferences[:anonymous_display_name] : user.login
    if post.user.blank?
      @preferences[:anonymous_display_name]
    else
      post.user.login
    end
  end
end
