module UsersHelper
  
  def link_to_user(obj)
    # TODO make obj.class work instead of casting to string
    case obj.class.to_s
    when "Post"
      return obj.display_name if obj.display_name == 'anonymous'
      link_to obj.display_name, edit_admin_user_path(obj.user)
    when "User"
      'Make link_to_user(User) work'
    else #???
      'link_to_user(obj) is in else case block'
    end
  end
end
