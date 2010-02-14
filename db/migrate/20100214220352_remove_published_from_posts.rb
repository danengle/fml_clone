class RemovePublishedFromPosts < ActiveRecord::Migration
  def self.up
    remove_column :posts, :published
  end

  def self.down
    add_column :posts, :published, :boolean, :default => false
  end
end
