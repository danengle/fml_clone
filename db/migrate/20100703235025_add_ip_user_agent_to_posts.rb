class AddIpUserAgentToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :ip_address, :string
    add_column :posts, :user_agent, :string
  end

  def self.down
    remove_column :posts, :ip_address
    remove_column :posts, :user_agent
  end
end
