class UserObserver < ActiveRecord::Observer
=begin  
  def after_create(user)
    user.reset_perishable_token!
    UserMailer.activation_email(user).deliver
  end
=end
end
