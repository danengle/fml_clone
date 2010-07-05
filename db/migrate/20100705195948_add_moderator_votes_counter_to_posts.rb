class AddModeratorVotesCounterToPosts < ActiveRecord::Migration
  # TODO FIXME after this migration I manually changed the name of the vote_counter column
  # on posts instead of using a migration. on second thought, being lazy and hopefully dont need to.
  # look into rename_column...should make this easy.
  def self.up
    add_column :posts, :moderator_up_vote_counter, :integer, :null => false, :default => 0
    add_column :posts, :moderator_down_vote_counter, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :posts, :moderator_up_vote_counter
    remove_column :posts, :moderator_down_vote_counter
  end
end
