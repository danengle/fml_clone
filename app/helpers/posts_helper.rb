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
end
