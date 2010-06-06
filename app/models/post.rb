class Post < ActiveRecord::Base
  include AASM
  
  aasm_column :state
  
  validates_presence_of :category_id, :body
  validates_presence_of :published_at, :if => Proc.new {|post| self.published? }
  belongs_to :category
  belongs_to :user
  has_many :comments, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  
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
  

  aasm_initial_state :unread
  aasm_state :unread
  aasm_state :viewed
  aasm_state :published
  #TODO save the datetime when a post is denied/unpublished. Make a unpublish event?
  aasm_state :denied, :enter => :clear_published_at
  aasm_state :deleted
  
  aasm_event :read do
    transitions :to => :viewed, :from => :unread
  end
  
  aasm_event :publish do
    transitions :to => :published, :from => [:viewed, :denied], :guard => Proc.new{|post| !post.published_at.blank? }
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
    user.blank? ? @preferences[:anonymous_display_name] : user.login
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
  
  def get_short_url(url)
    logger.info { "user:#{@preferences[:bitly_username]}, key:#{@preferences[:bitly_api_key]}" }
    url = Net::HTTP::Get.new("http://api.bit.ly/v3/shorten?login=#{@preferences[:bitly_username]}&apiKey=#{@preferences[:bitly_api_key]}&longUrl=#{URI.encode(url)}&format=txt")
    self.short_url = url
  end
end
