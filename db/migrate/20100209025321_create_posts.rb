class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :user_id
      t.integer :category_id
      t.text :body
      t.boolean :published
      t.datetime :published_at

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
