class Profile < ActiveRecord::Base
  acts_as_change_logger
  belongs_to :user
end
