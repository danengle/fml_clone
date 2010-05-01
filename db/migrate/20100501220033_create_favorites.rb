class CreateFavorites < ActiveRecord::Migration
  def self.up
    create_table :favorites do |t|
      t.integer :user_id, :post_id, :null => false
      t.timestamps
    end
    add_index :favorites, :user_id
  end

  def self.down
    drop_table :favorites
  end
end
