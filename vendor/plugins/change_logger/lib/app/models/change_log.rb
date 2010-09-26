class ChangeLog < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
  belongs_to :user, :foreign_key => "whodunnit"
  validates_presence_of :item_id, :item_type, :controller_name, :action_name
  
  scope :by_created_at, order('created_at desc')
  scope :affect, lambda { |user| where(['whodunnit = ? or (item_id = ? and item_type = ?) or (item_id = ? and item_type = ?)', user.id, user.id, 'User', user.profile.id, 'Profile'])}
end