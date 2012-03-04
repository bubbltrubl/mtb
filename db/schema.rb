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

ActiveRecord::Schema.define(:version => 20120227221453) do

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
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
    t.boolean  "admin",                                 :default => false
    t.index ["email"], :name => "index_users_on_email", :unique => true
    t.index ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id",                           :null => false
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
    t.string   "token"
    t.string   "secret"
    t.string   "name"
    t.boolean  "use_as_picture", :default => false
    t.index ["user_id"], :name => "index_authentications_on_user_id"
    t.foreign_key ["user_id"], "users", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "authentications_ibfk_1"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "nr_of_riders"
    t.string   "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cycling_teams", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.boolean  "active",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "races", :force => true do |t|
    t.string   "name"
    t.datetime "date"
    t.datetime "end_date"
    t.boolean  "is_tour"
    t.string   "previous_winner"
    t.integer  "race_id"
    t.integer  "category_id",                        :null => false
    t.boolean  "results_ready",   :default => false
    t.boolean  "team_time_trial", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["race_id"], :name => "index_races_on_race_id"
    t.index ["category_id"], :name => "index_races_on_category_id"
    t.foreign_key ["race_id"], "races", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "races_ibfk_1"
    t.foreign_key ["category_id"], "categories", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "races_ibfk_2"
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

  create_table "race_results", :force => true do |t|
    t.integer  "race_id",    :null => false
    t.integer  "rider_id",   :null => false
    t.integer  "position",   :null => false
    t.integer  "points",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["race_id"], :name => "index_race_results_on_race_id"
    t.index ["rider_id"], :name => "index_race_results_on_rider_id"
    t.foreign_key ["race_id"], "races", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "race_results_ibfk_1"
    t.foreign_key ["rider_id"], "riders", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "race_results_ibfk_2"
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

  create_table "race_teams", :force => true do |t|
    t.integer  "race_id",    :null => false
    t.integer  "team_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["race_id"], :name => "index_race_teams_on_race_id"
    t.index ["team_id"], :name => "index_race_teams_on_team_id"
    t.foreign_key ["race_id"], "races", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "race_teams_ibfk_1"
    t.foreign_key ["team_id"], "teams", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "race_teams_ibfk_2"
  end

  create_table "race_teams_riders", :id => false, :force => true do |t|
    t.integer "race_team_id", :null => false
    t.integer "rider_id",     :null => false
    t.index ["race_team_id"], :name => "index_race_teams_riders_on_race_team_id"
    t.index ["rider_id"], :name => "index_race_teams_riders_on_rider_id"
    t.foreign_key ["race_team_id"], "race_teams", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "race_teams_riders_ibfk_1"
    t.foreign_key ["rider_id"], "riders", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "race_teams_riders_ibfk_2"
  end

  create_table "riders_teams", :id => false, :force => true do |t|
    t.integer "team_id",  :null => false
    t.integer "rider_id", :null => false
    t.index ["team_id"], :name => "index_riders_teams_on_team_id"
    t.index ["rider_id"], :name => "index_riders_teams_on_rider_id"
    t.foreign_key ["team_id"], "teams", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "riders_teams_ibfk_1"
    t.foreign_key ["rider_id"], "riders", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "riders_teams_ibfk_2"
  end

  create_table "team_results", :force => true do |t|
    t.integer  "race_id",    :null => false
    t.integer  "team_id",    :null => false
    t.integer  "points",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["race_id"], :name => "index_team_results_on_race_id"
    t.index ["team_id"], :name => "index_team_results_on_team_id"
    t.foreign_key ["race_id"], "races", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "team_results_ibfk_1"
    t.foreign_key ["team_id"], "teams", ["id"], :on_update => :restrict, :on_delete => :restrict, :name => "team_results_ibfk_2"
  end

end
