# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120114141830) do

  create_table "cycling_teams", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.boolean  "active",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "riders", :force => true do |t|
    t.string   "name"
    t.integer  "value"
    t.integer  "points",          :default => 0
    t.boolean  "active",          :default => true
    t.integer  "cycling_team_id",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["cycling_team_id"], :name => "index_riders_on_cycling_team_id"
    t.foreign_key ["cycling_team_id"], "cycling_teams", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "riders_ibfk_1"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.index ["email"], :name => "index_users_on_email", :unique => true
    t.index ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.integer  "points",     :default => 0
    t.boolean  "paid",       :default => false
    t.integer  "user_id",                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], :name => "index_teams_on_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "teams_ibfk_1"
  end

  create_table "riders_teams", :id => false, :force => true do |t|
    t.integer "team_id",  :null => false
    t.integer "rider_id", :null => false
    t.index ["team_id"], :name => "index_riders_teams_on_team_id"
    t.index ["rider_id"], :name => "index_riders_teams_on_rider_id"
    t.foreign_key ["team_id"], "teams", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "riders_teams_ibfk_1"
    t.foreign_key ["rider_id"], "riders", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "riders_teams_ibfk_2"
  end

end
