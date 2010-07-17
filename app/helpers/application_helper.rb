module ApplicationHelper
  
  #TODO make this work
  # def posts_pagination_helper(obj)
    # content_tag(:div, :id => 'paginate' do
      # will_paginate(obj) + content_tag(:div, page_entries_info(obj), :class => 'page_entries')
    # end
  # end
  
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
    delete_button + activate_button + suspend_button
  end
  
  def suspend_delete_buttons
    delete_button + suspend_button
  end
  
  def unsuspend_delete_buttons
    delete_button + unsuspend_button
  end
  
  def activate_button
    button_to "Activate", activate_admin_user_path(@user), :class => 'awesome_button regular_button'
  end
  
  def suspend_button
    button_to "Suspend", suspend_admin_user_path(@user), :class => 'awesome_button', :confirm => 'Are you sure? This will send the user an email letting them know their account has been suspended.'
  end
  
  def unsuspend_button
    button_to "Unsuspend", unsuspend_admin_user_path(@user), :class => 'awesome_button regular_button', :confirm => 'Are you sure? This will send the user an email letting them know their account has been unsuspended.'
  end
  
  def delete_button
    button_to "Delete", delete_admin_user_path(@user), :class => 'negative_awesome_button small_round', :id => 'delete_button', :confirm => "Are you sure you want to delete this user?"
  end
  
  def admin_side_bar_links
    case controller_name
    when 'preferences'
      PreferenceCategory.all.map{|pc| {:text => pc.name, :path => admin_preference_path(pc.slug)}}
    else
      [{:text => controller_name, :path => admin_path}]
    end
  end
  
  def has_errors?(pref)
    @errors && @errors.any? {|msg| msg =~ /^#{pref.display_name}/}
  end
  
  def render_table(obj, options = {})
    render :partial => 'admin/shared/table_header', :locals => { :obj => obj, :options => options }
  end
  
  def show_id
    
  end
  def show_login(options)
    
  end
  def show_full_name
    
  end
  
  def show_admin_status
  
  end

  def display_result(r)
    r.is_a?(User) ? user_result(r) : post_result(r)
  end
  
  def user_result(r)
    render :partial => 'admin/search/user', :locals => { :user => r }
  end
  
  def post_result(r)
    render :partial => 'admin/search/post', :locals => { :post => r }
  end
end
