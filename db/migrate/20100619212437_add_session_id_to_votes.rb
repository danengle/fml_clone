class AddSessionIdToVotes < ActiveRecord::Migration
  def self.up
    add_column :votes, :session_id, :string
    add_index :votes, :session_id
  end

  def self.down
    remove_column :votes, :session_id
    remove_index :votes, :session_id
  end
end
