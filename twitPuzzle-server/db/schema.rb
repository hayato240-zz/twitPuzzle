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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130526100531) do

  create_table "friends", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "friend_id"
  end

  add_index "friends", ["user_id"], name: "index_friends_on_user_id"

  create_table "puzzles", force: true do |t|
    t.string   "tweet"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.binary   "image"
    t.string   "correct_order"
  end

  add_index "puzzles", ["user_id"], name: "index_puzzles_on_user_id"

  create_table "rankings", force: true do |t|
    t.float    "complete_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "puzzle_id"
    t.integer  "user_id"
  end

  add_index "rankings", ["puzzle_id"], name: "index_rankings_on_puzzle_id"
  add_index "rankings", ["user_id"], name: "index_rankings_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
