class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id, :null => false
      t.date :dob
      t.string :city
      t.string :country
      t.string :time_zone
      t.text :about_me
      t.boolean :hidden, :default => false
      t.timestamps
    end
    add_index :profiles, :user_id
  end

  def self.down
    drop_table :profiles
  end
end
