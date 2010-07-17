class ChangeLog < ActiveRecord::Base
  belongs_to :item, :polymorphic => true
  validates_presence_of :type, :type_id, :was, :is_now, :action_name, :controller_name
  
end