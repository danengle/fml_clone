class CreateFeatures < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
      t.integer :preference_id
      t.string :name, :null => false
      t.boolean :deployed, :default => false
      t.text :description
      t.timestamps
    end
    add_index :features, :name
  end

  def self.down
    drop_table :features
  end
end
