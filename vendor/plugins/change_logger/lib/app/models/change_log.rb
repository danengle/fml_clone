class ChangeLog < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
  belongs_to :user, :foreign_key => "whodunnit"
  validates_presence_of :item_id, :item_type, :controller_name, :action_name
end