# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100214003613) do

  create_table "categories", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], :name => "index_categories_on_name"

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.text     "body"
    t.boolean  "published"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_sessions", ["session_id"], :name => "index_user_sessions_on_session_id"
  add_index "user_sessions", ["updated_at"], :name => "index_user_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "full_name",          :limit => 40
    t.string   "login",              :limit => 40,  :default => ""
    t.string   "email",              :limit => 100,                        :null => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "perishable_token",   :limit => 64
    t.datetime "activated_at"
    t.string   "persistence_token"
    t.string   "state",                             :default => "passive", :null => false
    t.datetime "deleted_at"
    t.integer  "login_count",                       :default => 0,         :null => false
    t.integer  "failed_login_count",                :default => 0,         :null => false
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
