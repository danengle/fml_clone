class AddExtraColumnsToPreferences < ActiveRecord::Migration
  def self.up
    add_column :preferences, :display_name, :string
    add_column :preferences, :description, :text
  end

  def self.down
    remove_column :preferences, :display_name
    remove_column :preferences, :description
  end
end
