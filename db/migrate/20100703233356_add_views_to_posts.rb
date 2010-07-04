class AddViewsToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :view_counter, :integer, :default => 0
  end

  def self.down
    remove_column :posts, :view_counter
  end
end
