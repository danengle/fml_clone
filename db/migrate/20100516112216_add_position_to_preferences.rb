class AddPositionToPreferences < ActiveRecord::Migration
  def self.up
    add_column :preferences, :position, :integer, :null => false
  end

  def self.down
    remove_column :preferences, :position
  end
end
