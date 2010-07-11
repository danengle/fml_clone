class UserMailer < ActionMailer::Base
  default :from => "no+reply@fml.danengle.us"
  
  def activation_email(user)
    @user = user
    @url = "http://#{SITE_URL}/account/activate/#{user.perishable_token}"
    mail(:to => user.email,
         :subject => 'Welcome, please activate your account')
  end
  
  def password_reset_email(user)
    @user = user
    @url = "http://#{SITE_URL}/account/reset_password/#{user.perishable_token}"
    mail(:to => user.email, :subject => 'Password reset')
  end
  
  def account_suspended_email(user)
    @user = user
    @url = "http://#{SITE_URL}"
    mail(:to => @user.email, :subject => 'Your account has been suspended')
  end
  
  def account_unsuspended_email(user)
    @user = user
    @url = "http://#{SITE_URL}"
    mail(:to => @user.email, :subject => 'Your account has been unsuspended')
  end
end
