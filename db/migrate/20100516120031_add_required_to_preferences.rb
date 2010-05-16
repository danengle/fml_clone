class AddRequiredToPreferences < ActiveRecord::Migration
  def self.up
    add_column :preferences, :required, :boolean, :default => true
  end

  def self.down
    remove_column :preferences, :required
  end
end
