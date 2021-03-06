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

ActiveRecord::Schema.define(:version => 20150730014321) do

  create_table "bets", :force => true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.integer  "home_score"
    t.integer  "visitor_score"
    t.integer  "points",        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clubs", :force => true do |t|
    t.string "abr"
    t.string "name"
    t.string "logo"
  end

  create_table "games", :force => true do |t|
    t.integer  "camp_id"
    t.integer  "round"
    t.datetime "date"
    t.string   "stadium"
    t.string   "home_id"
    t.string   "visitor_id"
    t.integer  "home_score"
    t.integer  "visitor_score"
  end

  create_table "league_teams", :force => true do |t|
    t.integer  "user_id"
    t.integer  "club_id"
    t.string   "player"
    t.string   "position"
    t.boolean  "first"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stadiums", :force => true do |t|
    t.integer  "max_capaticy"
    t.string   "inauguration"
    t.string   "location"
    t.string   "name"
    t.string   "popular_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "standings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "position"
    t.integer  "club_id"
    t.integer  "round"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "name"
    t.string   "photo"
    t.datetime "last_access"
    t.string   "api_key"
  end

end
