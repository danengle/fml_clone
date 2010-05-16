module ApplicationHelper
  
  def current_user_actions
    content_tag(:div, 
    case @user.state
    when 'pending'
      activate_suspend_delete_buttons
    when 'active'
      suspend_delete_buttons
    when 'suspended'
      unsuspend_delete_buttons
    else # this shouldn't happen
    end, :class => 'user_actions')
  end
  
  def activate_suspend_delete_buttons
    activate_button + suspend_button + delete_button
  end
  
  def suspend_delete_buttons
    suspend_button + delete_button
  end
  
  def unsuspend_delete_buttons
    unsuspend_button + delete_button
  end
  
  def activate_button
    button_to "Activate", activate_admin_user_path(@user), :class => 'like_button'
  end
  
  def suspend_button
    button_to "Suspend", suspend_admin_user_path(@user), :class => 'like_button'
  end
  
  def unsuspend_button
    button_to "Unsuspend", unsuspend_admin_user_path(@user), :class => 'like_button'
  end
  
  def delete_button
    button_to "Delete", delete_admin_user_path(@user), :class => 'like_button', :confirm => "Are you sure you want to delete this user?"
  end
  
  def admin_side_bar_links
    case controller_name
    when 'preferences'
      PreferenceCategory.all.map{|pc| {:text => pc.name, :path => admin_preference_path(pc.name.underscore.gsub(/ /,'_'))}}
    else
      [{:text => controller_name, :path => admin_path}]
    end
  end
  
  def current_post_actions
    
  end
end
