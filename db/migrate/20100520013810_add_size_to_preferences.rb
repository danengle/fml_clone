class AddSizeToPreferences < ActiveRecord::Migration
  def self.up
    add_column :preferences, :large, :boolean, :default => false
  end

  def self.down
    remove_column :preferences, :large
  end
end
