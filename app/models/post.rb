class Post < ActiveRecord::Base
  include AASM
  
  aasm_column :state
  
  validates_presence_of :category_id, :body
  belongs_to :category
  belongs_to :user
  has_many :comments, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  
  # FIXME for some reason this returns posts with a publish date on same day but with time in future
  scope :published, lambda {
    where(["state = ? and published_at < ?", 'published', Time.now]).order('published_at desc')
  }
  scope :future_posts, lambda {
    where(["state = ? and published_at > ?", 'published', Time.now]).order('published_at desc')
  }
  scope :need_review,
    where({:state => 'unread'}).order('created_at desc')
  scope :reviewed,
    where({:state => ['viewed', 'published', 'denied']}).order('created_at desc')
  scope :by_category,
    lambda { |category| { :conditions => { :category_id => category.id }}}
  scope :by_period,
    lambda { |period| { :conditons => ['published_at >= ?', ]}}
  scope :sort_by_published, order('published_at desc')

  aasm_initial_state :unread
  aasm_state :unread
  aasm_state :viewed
  aasm_state :published
  aasm_state :denied
  aasm_state :deleted
  
  aasm_event :read do
    transitions :to => :viewed, :from => :unread
  end
  
  aasm_event :publish do
    transitions :to => :published, :from => [:viewed, :denied]
  end
  
  aasm_event :deny do
    transitions :to => :denied, :from => [:viewed, :published]
  end
  
  aasm_event :delete do
    transitions :to => :deleted, :from => [ :viewed, :published, :denied ]
  end
  
  def owner?(user)
    self.user == user
  end

  def currently_published?
    self.published? && self.published_at <= Time.now
  end

  def display_name
    user.blank? ? 'anonymous' : user.login
  end
=begin  
  def up_votes
    self.up_vote_counter
  end
  
  def down_votes
    self.down_vote_counter
  end
=end 
  def parent_comments
    self.comments.parent_comments
  end
  
  def scheduled_to_be_published?
    self.state == 'published' && self.published_at > Time.now
  end
end
