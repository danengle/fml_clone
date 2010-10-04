class AddAdditionalUserAgentColumnsToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :ip_address, :string
    add_column :comments, :user_agent, :string
    add_column :comments, :referrer, :string
    add_column :comments, :approved, :boolean
  end

  def self.down
    remove_column :comments, :ip_address
    remove_column :comments, :user_agent
    remove_column :comments, :referrer
    remove_column :comments, :approved
  end
end
