require 'aasm'
class User < ActiveRecord::Base
  include AASM
  acts_as_authentic

  has_many :posts
  has_many :comments
  has_many :favorites, :dependent => :destroy, :order => 'created_at desc'
  
  before_destroy :stop_bad_delete
  before_update :stop_bad_admin_transistion
  
  scope :not_deleted, where(['state != ?', 'deleted'])
  
  aasm_column :state
  aasm_initial_state :initial => :pending
  aasm_state :passive
  aasm_state :pending
  aasm_state :active,  :enter => :do_activate
  aasm_state :suspended
  aasm_state :deleted, :enter => :do_delete

  aasm_event :register do
    transitions :from => :passive, :to => :pending, :guard => Proc.new {|u| !(u.crypted_password.blank? && u.password.blank?) }
  end

  aasm_event :activate do
    transitions :from => :pending, :to => :active 
  end

  aasm_event :suspend do
    transitions :from => [:passive, :pending, :active], :to => :suspended
  end

  aasm_event :delete do
    transitions :from => [:passive, :pending, :active, :suspended], :to => :deleted
  end

  aasm_event :unsuspend do
    transitions :from => :suspended, :to => :active,  :guard => Proc.new {|u| !u.activated_at.blank? }
    transitions :from => :suspended, :to => :pending, :guard => Proc.new {|u| !u.activation_code.blank? }
    transitions :from => :suspended, :to => :passive
  end

  def recently_activated?
    @activated
  end

  def do_delete
    self.deleted_at = Time.now.utc
  end

  def do_activate
    @activated = true
    self.activated_at = Time.now.utc
    self.deleted_at = nil
  end

  def new_password(new_password)
    self.password = new_password[:password]
    self.password_confirmation = new_password[:password_confirmation]
    self.save
  end
  
  def stop_bad_delete
    User.count(:all, :conditions => ['state = ?', 'active']) > 1
  end
  
  def stop_bad_admin_transistion
    
  end
  
  def favorite?(post)
    self.favorites.exists?(:post_id => post.id)
  end
  
  def favorite_posts
    posts = []
    self.favorites.each{|f| posts << f.post }
    # posts = posts.sort{|a,b| b.published_at <=> a.published_at }
    posts
  end
  
  def number_of_posts
    self.posts.count
  end
  
  def number_of_comments
    self.comments.count
  end
end
