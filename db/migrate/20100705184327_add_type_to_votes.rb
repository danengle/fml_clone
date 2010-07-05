class AddTypeToVotes < ActiveRecord::Migration
  class Vote < ActiveRecord::Base 
  end
  def self.up
    add_column :votes, :type, :string, :null => false
    add_index :votes, [:type, :post_id]
    Vote.reset_column_information
    # FIXME this doesn't seem to be working.
    #this can be done because no other types of votes have been created yet.
    Vote.all do |vote|
      vote.update_attribute(:type, 'PostVote')
    end
  end

  def self.down
    remove_column :votes, :type
    remove_index :votes, [:type, :post_id]
  end
end
