class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :post_id, :null => false
      t.integer :user_id
      t.boolean :up_vote, :null => false
      t.timestamps
    end
    add_index :votes, [:post_id, :up_vote]
  end

  def self.down
    drop_table :votes
  end
end
