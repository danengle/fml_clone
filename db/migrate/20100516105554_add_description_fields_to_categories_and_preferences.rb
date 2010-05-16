class AddDescriptionFieldsToCategoriesAndPreferences < ActiveRecord::Migration
  def self.up
    add_column :preference_categories, :slug, :string, :null => false
    add_column :preference_categories, :description, :text
    add_column :categories, :description, :text
    add_column :categories, :slug, :string, :null => false
  end

  def self.down
    remove_column :preference_categories, :slug
    remove_column :preference_categories, :description
    remove_column :categories, :description
    remove_column :categories, :slug
  end
end

