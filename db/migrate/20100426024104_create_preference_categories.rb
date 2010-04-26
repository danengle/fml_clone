class CreatePreferenceCategories < ActiveRecord::Migration
  def self.up
    create_table :preference_categories do |t|
      t.string :name, :null => false
      t.integer :position
      t.timestamps
    end
    add_column :preferences, :preference_category_id, :integer, :null => false
    
    add_index :preferences, :preference_category_id
    add_index :preference_categories, :position
  end

  def self.down
    drop_table :preference_categories
    remove_column :preferences, :preference_category_id
  end
end
