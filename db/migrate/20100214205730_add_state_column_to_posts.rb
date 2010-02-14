class AddStateColumnToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :state, :string, :default => "unread", :null => false
    add_column :posts, :up_vote_counter, :integer, :default => 0, :null => false
    add_column :posts, :down_vote_counter, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :posts, :state
    remove_column :posts, :up_vote_counter
    remove_column :posts, :down_vote_counter
  end
end
