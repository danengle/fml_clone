class AddTweetedColumnToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :tweeted, :boolean, :default => false
  end

  def self.down
    remove_column :posts, :tweeted
  end
end
