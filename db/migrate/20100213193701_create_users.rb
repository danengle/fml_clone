class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :full_name, :limit => 40
      t.string :login, :limit => 40, :default => '', :null => true
      t.string :email, :limit => 100, :null => false
      t.string :crypted_password, :password_salt #, :limit => 64
      t.string :perishable_token, :limit => 64
      t.datetime :activated_at
      t.string :persistence_token
      t.string :state, :null => false, :default => 'passive'
      t.datetime :deleted_at
      t.integer :login_count, :null => false, :default => 0
      t.integer :failed_login_count, :null => false, :default => 0
      t.string :current_login_ip
      t.string :last_login_ip
      t.timestamps
    end
    add_index :users, :email, :unique => true
  end

  def self.down
    drop_table :users
  end
end
