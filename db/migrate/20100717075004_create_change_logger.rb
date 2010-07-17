class CreateChangeLogger < ActiveRecord::Migration
  def self.up
    create_table :change_logs do |t|
      t.integer :item_id, :null => false
      t.string :item_type, :controller_name, :action_name, :item_attribute, :null => false
      t.string :was, :is_now
      t.integer :whodunnit
      t.timestamps
    end
    add_index :change_logs, [:item_type, :item_id]
  end
  
  def self.down
    drop_table :change_logs
  end
end
