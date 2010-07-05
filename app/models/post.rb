class Post < ActiveRecord::Base
  include AASM
  has_paper_trail :ignore => [:up_vote_counter, :down_vote_counter, :view_counter, :moderator_up_vote_counter, :moderator_down_vote_counter]
  
  aasm_column :state
  
  validates_presence_of :category_id, :body
  validates_presence_of :published_at, :if => Proc.new {|post| self.published? }
  belongs_to :category
  belongs_to :user
  has_many :comments, :dependent => :destroy
  has_many :post_votes, :dependent => :destroy
  has_many :moderator_votes, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  
  define_index do
    indexes body
    indexes category(:name), :as => :category, :sortable => true
    indexes user(:login), :as => :author, :sortable => true
    has category_id, user_id, created_at, updated_at
    where "published_at is not null and published_at < NOW()"
  end
  # FIXME for some reason this returns posts with a publish date on same day but with time in future
  scope :published, lambda {
    where(["state = ? and published_at < ?", 'published', Time.now]).order('published_at desc')
  }
  scope :published_after, lambda { |time_period| where(['state = ? and published_at > ?', 'published', time_period]) }
  scope :future_posts, lambda {
    where(["state = ? and published_at > ?", 'published', Time.now]).order('published_at desc')
  }
  scope :need_review,
    where({:state => 'unread'}).order('created_at desc')
  scope :reviewed,
    where({:state => ['viewed', 'published', 'denied']}).order('created_at desc')
  scope :by_category,
    lambda { |category| { :conditions => { :category_id => category.id }}}
  scope :sort_by_published, order('published_at desc')
  scope :random_record, limit(1).order('rand()')
  scope :not_published,
    where({:state => ['viewed', 'unread']})

  aasm_initial_state :unread
  aasm_state :unread
  aasm_state :viewed
  aasm_state :published, :exit => :remove_published_at
  #TODO save the datetime when a post is denied/unpublished. Make a unpublish event?
  aasm_state :denied, :enter => :clear_published_at
  aasm_state :deleted
  
  aasm_event :read do
    transitions :to => :viewed, :from => :unread
  end
  
  aasm_event :publish do
    transitions :to => :published, :from => :viewed, :guard => Proc.new{|post| post.published_at.blank? }
  end
  
  aasm_event :unpublish do
    transitions :from => :published, :to => :viewed, :guard => Proc.new{|post| !post.published_at.blank? }
  end
  
  aasm_event :deny do
    transitions :to => :denied, :from => [:viewed, :published]
  end
  
  aasm_event :undeny do
    transitions :to => :viewed, :from => :denied
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

  def remove_published_at
    self.published_at = nil
  end
  
  # FIXME @preferences doesn't seem to be working inside model
  def display_name
    # user.blank? ? @preferences[:anonymous_display_name] : user.login
    if self.user.blank?
      @preferences[:anonymous_display_name]
    else
      self.user.login
    end
  end

  def parent_comments
    self.comments.parent_comments
  end
  
  def scheduled_to_be_published?
    self.published? && self.published_at > Time.now
  end
  
  def clear_published_at
    self.published_at = nil
  end
  
  def publish(datetime)
    datetime.each_pair do |key,value|
      case key
      when 'year'
        errors.add(:published_at, "year must be 4 digits.") unless value.length == 4
        next unless value.length == 4
        errors.add(:published_at, "year is too far in the past.") if value.to_i < (Time.now - 1.year).year
        errors.add(:published_at, "year is too far in the future.") if value.to_i > (Time.now + 1.year).year
      when 'month'
        errors.add(:published_at, "month is not a valid month.") unless value.to_i >= 1 && value.to_i <= 12
      when 'date'
        errors.add(:published_at, "date is not a valid date.") unless value.to_i >= 1 && value.to_i <= 31
      when 'hour'
        errors.add(:published_at, "hour is not a valid hour.") unless value.to_i >= 1 && value.to_i <= 23
      when 'minute'
        errors.add(:published_at, "minute is not a valid minute.") unless value.to_i >= 0 && value.to_i < 60
      else # this shouldn't happen
      end
    end
    begin
      date = DateTime.new(datetime[:year].to_i, datetime[:month].to_i, datetime[:date].to_i, datetime[:hour].to_i, datetime[:minute].to_i)
    rescue Exception => e
      errors.add(:published_at, "date is really messed up!")
    ensure
      return false unless errors.blank?
    end
    self.published_at = date
    self.publish!
  end
  
  def tweet
    
  end
  
end
