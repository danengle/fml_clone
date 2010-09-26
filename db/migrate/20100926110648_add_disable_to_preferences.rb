class AddDisableToPreferences < ActiveRecord::Migration
  def self.up
    add_column :preferences, :disabled, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :preferences, :disabled
  end
end
