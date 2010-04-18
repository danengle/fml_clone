class AddModifiableFlagToPreferences < ActiveRecord::Migration
  def self.up
    add_column :preferences, :modifiable, :boolean, :default => true
  end

  def self.down
    remove_column :preferences, :modifiable
  end
end
