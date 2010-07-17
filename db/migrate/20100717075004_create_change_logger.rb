class CreateChangeLogger < ActiveRecord::Migration
  def self.up
    create_table :change_logs do |t|
      t.integer :item_id, :null => false
      t.string :item_type, :null => false
      t.string :controller_name, :action_name, :was, :is_now, :null => false
      t.string :whodunnit
    end
  end
  
  def self.down
    drop_table :change_logs
  end
end
