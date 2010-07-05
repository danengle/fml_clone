class UserMailer < ActionMailer::Base
  default :from => "no+reply@danengle.us"
  
  def activation_email(user)
    @user = user
    @url = "http://localhost:3000/account/activate/#{user.perishable_token}"
    mail(:to => user.email,
         :subject => 'Welcome, please activate your account')
  end
  
  def password_reset_email(user)
    @user = user
    @url = "http://localhost:3000/account/reset_password/#{user.perishable_token}"
    mail(:to => user.email, :subject => 'Password reset')
  end
  
  def account_suspended_email(user)
    @user = user
    @url = "http://localhost:3000"
    mail(:to => @user.email, :subject => 'Your account has been suspended')
  end
  
  def account_unsuspended_email(user)
    @user = user
    @url = "http://localhost:3000"
    mail(:to => @user.email, :subject => 'Your account has been unsuspended')
  end
end
